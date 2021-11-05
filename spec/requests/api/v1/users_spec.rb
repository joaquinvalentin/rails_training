# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'Api::V1::Users', type: :request do
  fixtures :users
  let(:user) { users(:one) }

  describe 'GET /index' do
    context 'when is succesful' do
      it 'will show user' do
        get api_v1_user_path(user)
        assert_response :success
        # Test to ensure response contains the correct email
        json_response = JSON.parse(response.body)
        assert_equal user.email, json_response['email']
      end
    end
  end

  describe 'POST /index' do
    def create_call(user_params)
      post api_v1_users_path, params: { user: user_params }
    end

    context 'when is succesful' do
      let(:new_user) { { email: 'test@test.org', password: '123456' } }

      before { create_call(new_user) }

      it { expect(response).to have_http_status(:created) }
    end
  end
end
