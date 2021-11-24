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
    authorize user
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.render(user), status: :created
    else
      render_error(4022, user.errors.messages[:error])
    end
  end

  # PATCH/PUT /users/1
  def update
    authorize user
    if user.update(user_params)
      render json: UserSerializer.render(user), status: :ok
    else
      render_error(4023, user.errors.messages[:error])
    end
  end

  # DELETE /users/1
  def destroy
    authorize user
    user.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # TODO: Add error message
    # If current_user raise this exception for delete or update, it means that the user is not logged in
    # (and therefore not authorized to access this resource)
    if request.delete? || request.put?
      render_error(4010, exception.message)
    else
      render_error(4000, exception.message)
    end
  end

  rescue_from AuthenticationError do
    render_error(4011)
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def user
    @user ||= User.find(params[:id])
  end
end
