# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    def create_call(user_params)
      post :create, params: { user: user_params }
    end
    context 'when it is successful' do
      it 'returns http success' do
        create_call({ id: user.id, email: user.email, password: user.password })
        expect(response).to have_http_status(:success)
      end

      it 'returns a JWT token' do
        create_call({ id: user.id, email: user.email, password: user.password })
        expect(JSON.parse(response.body)['token']).to eql(JsonWebToken.encode(user_id: user.id))
      end
    end

    context 'when it is unsuccessful' do
      it 'returns http unprocessable entity' do
        create_call({ id: user.id, email: user.email, password: 'wrong_password' })
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
