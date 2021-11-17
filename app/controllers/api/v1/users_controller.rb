class Api::V1::UsersController < ApplicationController
  before_action :check_owner, only: %i[update destroy]

  # GET /users/1
  def show
    render json: UserSerializer.new(user).serializable_hash
  end

  # POST /users
  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user).serializable_hash, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if user.update(user_params)
      render json: UserSerializer.new(user).serializable_hash, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    user.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do
    # TODO: Add error message
    # If current_user raise this exception for delete or update, it means that the user is not logged in
    # (and therefore not authorized to access this resource)
    if request.delete? || request.put?
      head :unauthorized
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def check_owner
    head :unauthorized unless user.id == current_user&.id
  end
end
