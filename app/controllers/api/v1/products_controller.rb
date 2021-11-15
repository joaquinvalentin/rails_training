# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  include Authenticable

  before_action :check_login, only: %I[create]

  def index
    render json: ProductSerializer.render(Product.all)
  end

  def show
    render json: ProductSerializer.render(Product.find(params[:id]))
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: ProductSerializer.render(product), status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(4000, exception.message)
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end
