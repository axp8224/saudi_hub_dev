class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_one :profile

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end
end
