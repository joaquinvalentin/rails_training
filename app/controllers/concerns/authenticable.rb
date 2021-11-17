# frozen_string_literal: true

module Authenticable
  def current_user
    return @current_user if @current_user

    header = request.headers['Authorization']
    return nil if header.nil?

    decoded = JsonWebToken.decode(header)

    @current_user = begin
                      User.find(decoded[:user_id])
    rescue Failure
        raise AuthenticationError
    end
  end

  class AuthenticationError < StandardError
  end
end
