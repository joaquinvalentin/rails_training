# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/products', type: :request do
  # TODO: add examples for user with admin type.
  def authentication_token(user)
    "Bearer #{JsonWebToken.encode({ user_id: user.id })}"
  end

  def user
    @user ||= create(:user, :with_product)
  end

  def product
    @product ||= user.products.first
  end

  def admin
    @admin ||= create(:user, :is_admin)
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
        response '401', 'Unauthenticated' do
          let(:id) { product.id }
          let(:Authorization) { nil }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:id) { product.id }
          let(:Authorization) { authentication_token(admin) }

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

    path '/api/v1/products' do
      get 'Retrieve the list of products' do
        tags 'Products'
        description 'Get the list of products with their information.'
        produces 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        response '200', 'List returned' do
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
        response '401', 'Unauthenticated' do
          let(:Authorization) { nil }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '500', 'Internal server error' do
          let(:Authorization) { authentication_token(user) }

          document_response_without_test!
        end
      end
    end

    path '/api/v1/products' do
      post 'Create a product' do
        tags 'Products'
        description 'Create a product.'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            product: {
              type: :object,
              properties: {
                title: { type: :string },
                price: { type: :string },
                published: { type: :string }
              },
              required: %w[title price]
            },
            required: %w[product]
          }
        }
        response '201', 'Product created' do
          let(:Authorization) { authentication_token(user) }
          let(:params) { { product: attributes_for(:product) } }

          include_context 'with integration test'
        end
        response '401', 'Unauthenticated' do
          let(:params) { { product: attributes_for(:product) } }
          let(:Authorization) { nil }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:params) { { product: attributes_for(:product) } }
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '500', 'Internal server error' do
          let(:params) { { product: attributes_for(:product) } }
          let(:Authorization) { authentication_token(user) }

          document_response_without_test!
        end
      end
    end
  end
end
