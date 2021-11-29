# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  include Authenticable

  before_action :check_login

  def index
    products = policy_scope(Product)
    render json: ProductSerializer.render(products)
  end

  def show
    authorize product
    render json: ProductSerializer.render(product)
  end

  def create
    return render_error(4111) if current_user.admin?

    product = current_user.products.build(product_params)

    return render json: ProductSerializer.render(product), status: :created if product.save

    render_error(4200, product.errors.messages[:error])
  end

  def update
    authorize product
    return render json: ProductSerializer.render(product) if product.update(product_params)

    render_error(4201, product.errors.messages[:error])
  end

  def destroy
    authorize product
    product.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(4202, exception.message)
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    if current_user.admin?
      render_error(4205, exception.message)
    elsif exception.query == 'update?' || exception.query == 'destroy?'
      render_error(4203, exception.message)
    else
      render_error(5000)
    end
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def check_owner
    render_error(4203) unless product.user_id == current_user&.id
  end

  def product
    @product ||= Product.find(params[:id])
  end

  def check_login
    render_error(4204) unless current_user
  end
end
