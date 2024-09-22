class User < ApplicationRecord
  has_one_attached :avatar
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :major, optional: true

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url, major_id: Major.find_by(name: "").try(:id)).find_or_create_by!(email: email)
  end
end
