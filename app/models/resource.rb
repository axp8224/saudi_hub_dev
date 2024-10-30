require 'net/http'
require 'json'

class Resource < ApplicationRecord
  belongs_to :resource_type
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many_attached :images

  validates :title, presence: true
  validates :description, presence: true
  validates :resource_type, presence: true
  validates :status, presence: true, inclusion: { in: ['active', 'pending', 'archived'] }
  validate :images_are_images

  attr_accessor :distance

  after_validation :update_coordinates_with_geoapify, if: ->(obj){ obj.address.present? and obj.address_changed? }

  private

  def update_coordinates_with_geoapify
    coordinates = fetch_coordinates_with_geoapify(address)
    if coordinates
      self.latitude = coordinates[0]
      self.longitude = coordinates[1]
    else
      errors.add(:address, 'could not be geocoded')
    end
  end

  def fetch_coordinates_with_geoapify(address)
    api_key = ENV['GEOAPIFY_API_KEY']
    return unless api_key

    encoded_address = URI.encode_www_form_component(address)
    geoapify_url = "https://api.geoapify.com/v1/geocode/search?text=#{encoded_address}&apiKey=#{api_key}&limit=1"
  
    response = Net::HTTP.get(URI(geoapify_url))
    parsed_response = JSON.parse(response)

    if parsed_response['features'] && parsed_response['features'].any?
      coordinates = parsed_response['features'][0]['geometry']['coordinates']
      [coordinates[1], coordinates[0]]
    else
      nil
    end
  end

  def images_are_images
    return if images.empty? || images.nil?
    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png image/gif image/jpg])
        errors.add(:images, 'must be a JPG, JPEG, PNG, or GIF')
      end
    end
  end
end
