# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  def show
    render json: ProductSerializer.render(Product.find(params[:id]))
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(4000, exception.message)
  end
end
