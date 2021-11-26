# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :check_login

  # GET /users/1
  def show
    authorize user
    render json: UserSerializer.render(user)
  end

  # POST /users
  def create
    user = User.new(user_params)
    authorize user
    return render_error(4106) if user_by_email

    if user.save
      render json: UserSerializer.render(user), status: :created
    else
      render_error(4104, user.errors.messages[:error])
    end
  end

  # PATCH/PUT /users/1
  def update
    authorize user
    return render_error(4106) if user_by_email

    if user.update(user_params)
      render json: UserSerializer.render(user), status: :ok
    else
      render_error(4105, user.errors.messages[:error])
    end
  end

  # DELETE /users/1
  def destroy
    authorize user
    user.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(4100, exception.message)
  end

  rescue_from AuthenticationError do
    render_error(4107)
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
end
