class User < ApplicationRecord
  has_one_attached :avatar
  devise :omniauthable, :trackable, omniauth_providers: [:google_oauth2]
  belongs_to :role
  belongs_to :major, optional: true, class_name: 'Major', foreign_key: 'major_id'
  belongs_to :class_year, optional: true, class_name: 'ClassYear', foreign_key: 'class_year_id'

  validate :acceptable_avatar
  validates :grad_year, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: Time.now.year + 10 }, allow_nil: true

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url, major_id: Major.find_by(name: "").try(:id)).find_or_create_by!(email: email)
  end

  private
  def acceptable_avatar
    return unless avatar.attached?

    allowed_types = ['image/jpeg', 'image/png']
    unless allowed_types.include?(avatar.content_type)
      errors.add(:avatar, I18n.t('users.edit.error_messages.file_type_error'))
    end

    if avatar.attached? && avatar.blob.byte_size > 2.megabytes
      errors.add(:avatar, 'is too large. Please, choose an avatar smaller than 2MB.')
    end
  end

  has_many :resources, foreign_key: 'user_id'
end
