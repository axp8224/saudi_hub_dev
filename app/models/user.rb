class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :role, optional: false
  belongs_to :major, optional: true
  belongs_to :class_year, optional: true

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    user_role = Role.find_by(name: "user");
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url, role: user_role).find_or_create_by!(email: email)
  end
end
