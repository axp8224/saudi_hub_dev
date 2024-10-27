class Resource < ApplicationRecord
  belongs_to :resource_type
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many_attached :images

  validates :title, presence: true
  validates :description, presence: true
  validates :resource_type, presence: true
  validates :status, presence: true, inclusion: { in: ['active', 'pending', 'archived', 'rejected'] }
  validate :images_are_images

  private

  def images_are_images
    return if images.empty? || images.nil?
    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png image/gif image/jpg])
        errors.add(:images, 'must be a JPG, JPEG, PNG, or GIF')
      end
    end
  end
end
