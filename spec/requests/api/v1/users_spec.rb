# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  describe 'Users' do
    # path '/api/v1/users' do
    #   # TODO: def authenticate user
    #   post('create user') do
    #     response(200, 'successful') do
    #       after do |example|
    #         example.metadata[:response][:content] = {
    #           'application/json' => {
    #             example: JSON.parse(response.body, symbolize_names: true)
    #           }
    #         }
    #       end

    #       run_test!
    #     end
    #   end
    # end
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

    # path '/api/v1/users/{id}' do
    #   # You'll want to customize the parameter types...
    #   parameter name: 'id', in: :path, type: :string, description: 'id'

    #   get('show user') do
    #     response(200, 'successful') do
    #       let(:id) { '123' }

    #       after do |example|
    #         example.metadata[:response][:content] = {
    #           'application/json' => {
    #             example: JSON.parse(response.body, symbolize_names: true)
    #           }
    #         }
    #       end

    #       run_test!
    #     end
    #   end

    #   patch('update user') do
    #     response(200, 'successful') do
    #       let(:id) { '123' }

    #       after do |example|
    #         example.metadata[:response][:content] = {
    #           'application/json' => {
    #             example: JSON.parse(response.body, symbolize_names: true)
    #           }
    #         }
    #       end

    #       run_test!
    #     end
    #   end

    #   put('update user') do
    #     response(200, 'successful') do
    #       let(:id) { '123' }

    #       after do |example|
    #         example.metadata[:response][:content] = {
    #           'application/json' => {
    #             example: JSON.parse(response.body, symbolize_names: true)
    #           }
    #         }
    #       end

    #       run_test!
    #     end
    #   end

    #   delete('delete user') do
    #     response(200, 'successful') do
    #       let(:id) { '123' }

    #       after do |example|
    #         example.metadata[:response][:content] = {
    #           'application/json' => {
    #             example: JSON.parse(response.body, symbolize_names: true)
    #           }
    #         }
    #       end

    #       run_test!
    #     end
    #   end
    # end
  end
end
