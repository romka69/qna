module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '123545',
        'info' => {
            'email' => 'user@test.com'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    }
  end
end
