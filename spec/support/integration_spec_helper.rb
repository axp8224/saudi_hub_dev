module IntegrationSpecHelper
  def login_with_oauth(service = :google)
    visit "/auth/#{service}"
  end

  def omniauth_mock_auth_hash
    sample_user = User.find_by(email: 'sample@example.com')
    
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: sample_user.uid,
      info: {
        email: sample_user.email,
        name: sample_user.full_name,
        image: sample_user.avatar_url
      },
      credentials: {
        token: 'mock_token',
        expires_at: 1.week.from_now.to_i
      }
    })
  end

  def omniauth_mock_auth_hash_ADMIN
    sample_admin = User.find_by(email: 'admin@example.com')
    
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: sample_admin.uid,
      info: {
        email: sample_admin.email,
        name: sample_admin.full_name,
        image: sample_admin.avatar_url
      },
      credentials: {
        token: 'mock_token',
        expires_at: 1.week.from_now.to_i
      }
    })
  end

end