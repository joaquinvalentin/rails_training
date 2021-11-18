# frozen_string_literal: true

module AuthenticationHelper
  def create_authenticated_user
    user = User.first || FactoryBot.create(:user)
    payload = { user_id: user.id }
    jwt = JsonWebToken.encode(payload)
    @request.headers['Authorization'] = "Bearer #{jwt}"
    user
  end

  def create_authenticated_user_with_products
    user = FactoryBot.create(:user, :with_products)
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
end
