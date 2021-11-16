# frozen_string_literal: true

module AuthenticationHelper
  def authenticate_user(id)
    payload = { user_id: id }
    jwt = JsonWebToken.encode(payload)
    "Bearer #{jwt}"
  end
end
