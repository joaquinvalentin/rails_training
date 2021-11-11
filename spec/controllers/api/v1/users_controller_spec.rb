# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'when is successful' do
      before { get :show, params: { id: user.id } }

      it 'return successful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        # Test to ensure response contains the correct email
        expect(JSON.parse(response.body)['data']['attributes']['email']).to eql(user.email)
      end
    end

    context 'when is not successful' do
      before { get :show, params: { id: 0 } }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(JSON.parse(response.body)['error']).to eql('User not found')
      end
    end
  end

  describe 'POST #create' do
    def create_call(user_params)
      post :create, params: { user: user_params }
    end

    context 'when is successful' do
      let(:new_user) { { email: 'test@test.org', password: '123456' } }

      before { create_call(new_user) }

      it 'returns successful' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the user' do
        expect(JSON.parse(response.body)['data']['attributes']['email']).to eql(new_user[:email])
      end
    end

    context 'when is not successful' do
      let(:new_user) { { email: 'test.org', password: '123456' } }

      before { create_call(new_user) }

      it 'returns code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error' do
        expect(JSON.parse(response.body)['error']).to eql(['is not an email'])
      end
    end
  end

  describe 'PUT #update' do
    def update_user_call(user_params, headers)
      request.headers.merge! headers
      put :update, params: { id: user.id, user: user_params }
    end

    context 'when is successful' do
      let(:user_params) { { email: 'email@dominio.com', password: '123456' } }
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before { update_user_call(user_params, headers) }

      it 'returns successful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        expect(JSON.parse(response.body)['data']['attributes']['email']).to eql('email@dominio.com')
      end
    end

    context 'when params are invalid' do
      let(:user_params) { { email: 'bad_email', password: '123456' } }
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before { update_user_call(user_params, headers) }

      it 'returns a error' do
        expect(JSON.parse(response.body)['error']).to eql(['is not an email'])
      end

      it 'error status is 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when headers are nil' do
      let(:user_params) { { email: 'email@dominio.com', password: '123456' } }

      before { update_user_call(user_params, {}) }

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when token is invalid' do
      let(:user_params) { { email: 'email@dominio.com', password: '123456' } }
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id + 1) }
      end

      before { update_user_call(user_params, headers) }

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_user_call(user_to_destroy, headers)
      request.headers.merge! headers
      delete :destroy, params: { id: user_to_destroy }
    end

    context 'when is successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before { delete_user_call(user, headers) }

      it 'returns no content' do
        expect(response).to have_http_status(:no_content)
      end

      it 'destroy the user' do
        expect(User.find_by(id: user.id).nil?).to be(true)
      end
    end

    context 'when the user is other' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before { delete_user_call(user.id + 1, headers) }

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when headers are nil' do
      before { delete_user_call(user, {}) }

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when token is invalid' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id + 1) }
      end

      before { delete_user_call(user, headers) }

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
