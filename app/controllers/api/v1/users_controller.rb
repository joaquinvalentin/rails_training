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
    user = User.new(user_params)
    authorize user
    return render_error(4106) if user_by_email

    if user.save
      UserMailer.with(user: user).welcome_email.deliver_later

      return render json: UserSerializer.render(user), status: :created
    end

    render_error(4104, user.errors.messages[:error])
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
    params.require(:user).permit(:email, :password)
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
end
