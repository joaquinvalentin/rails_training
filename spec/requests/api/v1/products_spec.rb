# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/products', type: :request do
  # TODO: add examples for user with admin type.
  def authentication_token(user)
    "Bearer #{JsonWebToken.encode({ user_id: user.id })}"
  end

  def user
    @user ||= create(:user, :with_products)
  end

  def product
    @product ||= user.products.first
  end

  describe 'Products' do
    path '/api/v1/products/{id}' do
      get 'Retrieve a product' do
        tags 'Products'
        description 'Get the product information.'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string
        parameter name: :Authorization, in: :header, type: :string
        response '200', 'Product found' do
          let(:id) { product.id }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
        response '404', 'Product not found' do
          let(:id) { 0 }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
        response '500', 'Internal server error' do
          let(:id) { 'invalid' }
          let(:Authorization) { authentication_token(user) }

          document_response_without_test!
        end
      end
    end
  end
end
