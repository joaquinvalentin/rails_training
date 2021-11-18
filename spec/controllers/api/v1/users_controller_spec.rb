# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe Api::V1::UsersController, type: :controller do
  def user
    @user ||= create(:user)
  end

  def authenticated_user
    @authenticated_user ||= create_authenticated_user
  end

  describe 'GET #show' do
    context 'when is successful' do
      before { get :show, params: { id: user.id } }

      it 'return successful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        # Test to ensure response contains the correct email

        expect(JSON.parse(response.body)['email']).to eql(user.email)
      end
    end

    context 'when is not successful' do
      before { get :show, params: { id: 0 } }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find User with 'id'=0")
      end

      it 'returns the error code 4000' do
        expect(JSON.parse(response.body)['error_code']).to be(4000)
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
        expect(JSON.parse(response.body)['email']).to eql(new_user[:email])
      end
    end

    context 'when is not successful' do
      let(:new_user) { { email: 'test.org', password: '123456' } }

      before { create_call(new_user) }

      it 'returns http code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error' do
        expect(JSON.parse(response.body)['details']).to eql(['is not an email'])
      end

      it 'returns the error code 4022' do
        expect(JSON.parse(response.body)['error_code']).to be(4022)
      end
    end
  end

  describe 'PUT #update' do
    def user_params
      @user_params = { email: 'email@dominio.com', password: '123456' }
    end

    def update_user_call(user)
      put :update, params: { id: user.id, user: user_params }
    end

    context 'when is successful' do
      before { update_user_call(authenticated_user) }

      it 'returns successful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        expect(JSON.parse(response.body)['email']).to eql('email@dominio.com')
      end
    end

    context 'when params are invalid' do
      let(:user_params) { { email: 'bad_email', password: '123456' } }

      before { update_user_call(authenticated_user) }

      it 'returns an error' do
        expect(JSON.parse(response.body)['details']).to eql(['is not an email'])
      end

      it 'error status is 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error code 4023' do
        expect(JSON.parse(response.body)['error_code']).to be(4023)
      end
    end

    context 'when headers are nil' do
      it 'returns forbidden' do
        request.headers['Authorization'] = nil
        update_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when token is invalid' do
      it 'returns unauthorized' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        update_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4011' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        update_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4011)
      end

      it 'returns the error message' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        update_user_call(user)
        error_message = 'User can not be deleted or updated due to unauthorized'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_user_call(user_to_destroy)
      delete :destroy, params: { id: user_to_destroy.id }
    end

    context 'when is successful' do
      before { delete_user_call(authenticated_user) }

      it 'returns no content' do
        expect(response).to have_http_status(:no_content)
      end

      it 'destroy the user' do
        expect(User.find_by(id: authenticated_user.id).nil?).to be(true)
      end
    end

    context 'when the user is other' do
      it 'returns unauthorized' do
        authenticated_user
        delete_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4011' do
        authenticated_user
        delete_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4011)
      end

      it 'returns the error message' do
        authenticated_user
        delete_user_call(user)
        error_message = 'User can not be deleted or updated due to unauthorized'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end

    context 'when headers are nil' do
      it 'returns unauthorized' do
        request.headers['Authorization'] = nil
        delete_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4011' do
        request.headers['Authorization'] = nil
        delete_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4011)
      end
    end

    context 'when token is invalid' do
      it 'returns unauthorized' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4010' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4011)
      end

      it 'returns the error message' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete_user_call(user)
        error_message = 'User can not be deleted or updated due to unauthorized'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end
  end
end
