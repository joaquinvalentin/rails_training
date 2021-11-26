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
    if product.save
      render json: ProductSerializer.render(product), status: :created
    else
      render_error(4200, product.errors.messages[:error])
    end
  end

  def update
    if product.update(product_params)
        render json: ProductSerializer.render(product)
      else
        render_error(4201, product.errors.messages[:error])
      end
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
    if current_user
      render_error(4203) unless product.user_id == current_user&.id
    else
      render_error(4002)
    end
  end

  def product
    @product ||= Product.find(params[:id])
  end
end
