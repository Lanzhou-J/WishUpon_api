module AuthenticationHelpers
  def authenticated_header
    user = create(:user)

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    return {'Authorization': "Bearer #{token}"}
  end

  def authenticate_user(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    return {'Authorization': "Bearer #{token}"}    
  end

end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end