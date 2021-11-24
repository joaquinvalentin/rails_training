# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/tokens', type: :request do
  describe 'Tokens' do
    def user
      @user ||= create(:user)
    end

    def params
      { user: attributes_for(:user) }
    end
    path '/api/v1/tokens' do
      post :create do
        tags 'Token'
        description 'Get a Json Web Token.'
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
        response '200', 'User created' do
          let(:params) { { user: { email: user.email, password: user.password } } }

          include_context 'with integration test'
        end
        response '401', 'User not found' do
          let(:params) { { user: { email: 'user.email', password: user.password } } }

          include_context 'with integration test'
        end

        response '500', 'Internal server error' do
          let(:params) { { user: { email: 'user.email', password: user.password } } }

          document_response_without_test!
        end
      end
    end
  end
end
