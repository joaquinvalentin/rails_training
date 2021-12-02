# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  include Authenticable

  before_action :check_login, only: %I[create]
  before_action :check_owner, only: %I[update destroy]

  def index
    render json: ProductSerializer.render(Product.all)
  end

  def show
    render json: ProductSerializer.render(product)
  end

  def create
    product = current_user.products.build(product_params)

    return render json: ProductSerializer.render(product), status: :created if product.save

    render_error(4200, product.errors.messages[:error])
  end

  def update
    return render json: ProductSerializer.render(product) if product.update(product_params)

    render_error(4201, product.errors.messages[:error])
  end

  def destroy
    product.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(4202, exception.message)
  end

  private

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
