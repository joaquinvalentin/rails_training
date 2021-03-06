# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  def authentication_token(user)
    "Bearer #{JsonWebToken.encode({ user_id: user.id })}"
  end

  def user
    @user ||= create(:user)
  end

  def admin
    @admin ||= create(:user, :is_admin)
  end

  describe 'Users' do
    path '/api/v1/users/{id}' do
      get 'Retrieve a user' do
        tags 'Users'
        description 'Get the user information.'
        produces 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer
        response '200', 'User found' do
          let(:id) { admin.id }
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '401', 'Unauthenticated' do
          let(:id) { admin.id }
          let(:Authorization) { nil }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:id) { admin.id }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
        response '404', 'User not found' do
          let(:id) { 0 }
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '500', 'Internal server error' do
          let(:id) { 'invalid' }
          let(:Authorization) { authentication_token(admin) }

          document_response_without_test!
        end
      end
    end

    path '/api/v1/users' do
      post 'Create a user' do
        tags 'Users'
        description 'Create a user.'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
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
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '401', 'Unauthenticated' do
          let(:params) { { user: attributes_for(:user) } }
          let(:Authorization) { nil }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:params) { { user: attributes_for(:user) } }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
        response '422', 'Bad parameter' do
          let(:params) { { user: { email: 'bad_email', password: 'asd' } } }
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '500', 'Internal server error' do
          let(:params) { { user: { email: nil, password: nil } } }
          let(:Authorization) { authentication_token(admin) }

          document_response_without_test!
        end
      end
    end

    path '/api/v1/users/{id}' do
      put 'Update a user' do
        tags 'Users'
        description 'Update a user.'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer
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
          let(:id) { user.id }
          let(:params) { { user: attributes_for(:user) } }
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '401', 'Unauthenticated' do
          let(:id) { admin.id }
          let(:params) { { user: attributes_for(:user) } }
          let(:Authorization) { '' }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:id) { admin.id }
          let(:params) { { user: attributes_for(:user) } }
          let(:Authorization) { authentication_token(user) }

          include_context 'with integration test'
        end
        response '422', 'Bad parameter' do
          let(:id) { admin.id }
          let(:params) { { user: { email: 'bad_email', password: 'asd' } } }
          let(:Authorization) { authentication_token(admin) }

          include_context 'with integration test'
        end
        response '500', 'Internal server error' do
          let(:id) { admin.id }
          let(:params) { { user: { email: nil, password: nil } } }
          let(:Authorization) { authentication_token(admin) }

          document_response_without_test!
        end
      end
    end

    path '/api/v1/users/{id}' do
      delete 'Delete a user' do
        tags 'Users'
        description 'Delete a user.'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer
        response '204', 'User deleted' do
          let(:id) { admin.id }
          let(:Authorization) { authentication_token(admin) }

          run_test!
        end
        response '401', 'Unauthenticated' do
          let(:id) { admin.id }
          let(:Authorization) { '' }

          include_context 'with integration test'
        end
        response '403', 'Unauthorized' do
          let(:id) { admin.id }
          let(:Authorization) { authentication_token(user) }

          run_test!
        end
        response '500', 'Internal server error' do
          let(:id) { '___' }
          let(:Authorization) { authentication_token(admin) }

          document_response_without_test!
        end
      end
    end
  end
end
