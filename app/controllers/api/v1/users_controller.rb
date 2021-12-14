# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :check_login
  before_action :check_permissions, only: %I[show update destroy]

  # GET /users/1
  def show
    render json: UserSerializer.render(user)
  end

  # POST /users
  def create
    service = create_user_service.call(user_params: user_params, creator: current_user)

    return render_error(service.error_code) unless service.success?

    render json: UserSerializer.render(service.user), status: :created
  end

  # PATCH/PUT /users/1
  def update
    return render_error(4106) if user_by_email

    return render json: UserSerializer.render(user), status: :ok if user.update(user_params)

    render_error(4105, user.errors.messages[:error])
  end

  # DELETE /users/1
  def destroy
    user.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(4100, exception.message)
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    render_error(4103, exception.message)
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def user_by_email
    User.find_by_email(user_params[:email])
  end

  def check_permissions
    authorize user
  end

  def check_login
    render_error(4107) unless current_user
  end

  def send_email(user)
    UserMailer.with(user: user, admin: current_user.email).welcome_email.deliver_now
  end

  def create_user_service
    @create_user_service ||= CreateUser
  end
end
