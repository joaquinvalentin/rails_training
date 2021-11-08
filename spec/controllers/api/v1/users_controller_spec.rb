# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe Api::V1::UsersController, type: :controller do
  fixtures :users
  let(:user) { users(:one) }

  describe 'GET #show' do
    context 'when is succesful' do
      before { get :show, params: { id: user.id } }

      it 'return succesful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        # Test to ensure response contains the correct email
        expect(JSON.parse(response.body)).to include('email' => user.email)
      end
    end

    context 'when is not succesful' do
      before { get :show, params: { id: 0 } }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(response.body).to include('User not found')
      end
    end
  end

  describe 'POST #create' do
    def create_call(user_params)
      post :create, params: { user: user_params }
    end

    context 'when is succesful' do
      let(:new_user) { { email: 'test@test.org', password: '123456' } }

      before { create_call(new_user) }

      it 'returns successful' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the user' do
        expect(JSON.parse(response.body)).to include('email' => new_user[:email])
      end
    end

    context 'when is not succesful' do
      let(:new_user) { { email: 'test.org', password: '123456' } }

      before { create_call(new_user) }

      it 'returns code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error' do
        expect(JSON.parse(response.body)).to include('email' => ['is invalid'])
      end
    end
  end

  describe 'PUT #update' do
    def update_user_call(user_params)
      put :update, params: { id: user.id, user: user_params }
    end

    context 'when is succesful' do
      let(:user_params) { { email: 'email@dominio.com', password: '123456' } }

      before { update_user_call(user_params) }

      it 'returns succesful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        expect(JSON.parse(response.body)).to include('email' => 'email@dominio.com')
      end
    end

    context 'when params are invalid' do
      let(:user_params) { { email: 'bad_email', password: '123456' } }

      before { update_user_call(user_params) }

      it 'returns a error' do
        expect(JSON.parse(response.body)).to include('email' => ['is invalid'])
      end

      it 'error status is 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_user_call(user_to_destroy)
      delete :destroy, params: { id: user_to_destroy }
    end

    context 'when is succesful' do
      before { delete_user_call(user) }

      it 'returns no content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when is not succesful' do
      before { delete_user_call(user.id + 1) }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(response.body).to include('User not found')
      end
    end
  end
end
