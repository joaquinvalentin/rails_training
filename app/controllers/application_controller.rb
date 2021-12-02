# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticable
  include ErrorHandler
  include Pundit
  skip_before_action :verify_authenticity_token
  helper_method :destroy_admin_user_session_path

  def authenticate_active_admin_user!
    if user&.admin
      request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(user_id: user.id)}"
      current_user
    else
      flash[:alert] = 'Unauthorized Access!'
      request.headers['Authorization'] = nil
      redirect_to '/'
    end
  end

  def destroy_admin_user_session_path
    request.headers['Authorization'] = nil
    '/'
  end

  def user
    if current_user.nil?
      authenticate_user!
    else
      current_user
    end
  end
end
