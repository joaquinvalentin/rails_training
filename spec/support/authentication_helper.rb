# frozen_string_literal: true

module AuthenticationHelper
  def create_authenticated_user
    user = FactoryBot.create(:user)
    payload = { user_id: user.id }
    jwt = JsonWebToken.encode(payload)
    @request.headers['Authorization'] = "Bearer #{jwt}"
    user
  end

  def authenticate_user(user)
    payload = { user_id: user.id }
    jwt = JsonWebToken.encode(payload)
    @request.headers['Authorization'] = "Bearer #{jwt}"
  end

  def create_authenticated_admin
    user = FactoryBot.create(:user, :is_admin)
    payload = { user_id: user.id }
    jwt = JsonWebToken.encode(payload)
    @request.headers['Authorization'] = "Bearer #{jwt}"
    user
  end

  def create_auth_user_with_prod
    user = FactoryBot.create(:user, :with_product)
    payload = { user_id: user.id }
    jwt = JsonWebToken.encode(payload)
    @request.headers['Authorization'] = "Bearer #{jwt}"
    user
  end
end
