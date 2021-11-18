# frozen_string_literal: true

class Api::V1::TokensController < ApplicationController
  def create
    authenticated = user&.authenticate(user_params[:password])
    return render_error(4011) unless authenticated

    render json: {
      token: JsonWebToken.encode(user_id: user.id),
      email: user.email
    }
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password, :id)
  end

  def user
    @user ||= User.find_by_email(user_params[:email])
  end
end
