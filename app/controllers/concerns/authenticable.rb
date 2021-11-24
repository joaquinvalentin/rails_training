# frozen_string_literal: true

module Authenticable
  include ErrorHandler

  def current_user
    return @current_user if @current_user

    header = request.headers['Authorization']
    return nil if header.nil?

    @current_user = begin
                        decoded = JsonWebToken.decode(header.split(' ').last)
                        User.find(decoded[:user_id])
    rescue StandardError
        raise AuthenticationError
    end
  end

  class AuthenticationError < StandardError
  end
end
