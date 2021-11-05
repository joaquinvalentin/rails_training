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
end
