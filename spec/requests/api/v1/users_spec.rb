# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  def authentication_token(user)
    "Bearer #{JsonWebToken.encode({ user_id: user.id })}"
  end

  describe 'Users' do
    path '/api/v1/users/{id}' do
      get 'Retrieve a user' do
        tags 'Users'
        description 'Get the user information.'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string
        response '200', 'User found' do
          let(:user) { create(:user) }
          let(:id) { user.id }

          include_context 'with integration test'
        end
      end
    end

    path '/api/v1/users' do
      post 'Create a user' do
        tags 'Users'
        description 'Create a user.'
        consumes 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string }
              },
              required: %w[email password]
            },
            required: %w[user]
          }
        }
        response '201', 'User created' do
          let(:params) { { user: attributes_for(:user) } }

          include_context 'with integration test'
        end
      end
    end

    path '/api/v1/users/{id}' do
      put 'Update a user' do
        tags 'Users'
        description 'Update a user.'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string }
              },
              required: %w[email password]
            },
            required: %w[user]
          }
        }
        response '200', 'User updated' do
          let(:user) { create(:user) }
          let(:id) { user.id }
          let(:params) { { user: attributes_for(:user) } }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
      end
    end

    path '/api/v1/users/{id}' do
      delete 'Delete a user' do
        tags 'Users'
        description 'Delete a user.'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string
        response '200', 'User deleted' do
          let(:user) { create(:user) }
          let(:id) { user.id }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
      end
    end
  end
end
