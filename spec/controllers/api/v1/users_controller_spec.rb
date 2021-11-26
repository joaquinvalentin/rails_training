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

  def admin
    @admin ||= create(:user, :is_admin)
  end

  def authenticated_admin
    @authenticated_admin ||= create_authenticated_admin
  end

  describe 'GET #show' do
    def make_request(user)
      get :show, params: { id: user.id }
    end

    context 'when the user is admin and was authenticated' do
      it 'return successful' do
        make_request(authenticated_admin)
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        make_request(authenticated_admin)
        # Test to ensure response contains the correct email

        expect(JSON.parse(response.body)['email']).to eql(authenticated_admin.email)
      end
    end

    context 'when the user is not logged' do
      it 'return unauthorized' do
        make_request(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error message ' do
        make_request(user)
        error_message = 'Cannot perform this action due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4002' do
        make_request(user)
        expect(JSON.parse(response.body)['error_code']).to be(4002)
      end
    end

    context 'when the user is logged but is not admin' do
      it 'return forbidden' do
        authenticate_user(user)
        make_request(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error message ' do
        authenticate_user(user)
        make_request(user)
        error_message = 'User cannot perform this action due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4103' do
        authenticate_user(user)
        make_request(user)
        expect(JSON.parse(response.body)['error_code']).to be(4103)
      end
    end

    context 'when the user does not exists' do
      it 'returns not found' do
        create_authenticated_admin
        user.id = 0
        make_request(user)
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        create_authenticated_admin
        user.id = 0
        make_request(user)
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find User with 'id'=0")
      end

      it 'returns the error code 4100' do
        create_authenticated_admin
        user.id = 0
        make_request(user)
        expect(JSON.parse(response.body)['error_code']).to be(4100)
      end
    end
  end

  describe 'POST #create' do
    def create_call(user_params)
      post :create, params: { user: user_params }
    end

    context 'when the user is admin and was authenticated' do
      let(:new_user) { { email: 'test@test.org', password: '123456' } }

      it 'returns successful' do
        authenticate_user(admin)
        create_call(new_user)
        expect(response).to have_http_status(:created)
      end

      it 'returns the user' do
        authenticate_user(admin)
        create_call(new_user)
        expect(JSON.parse(response.body)['email']).to eql(new_user[:email])
      end
    end

    context 'when the user is not admin' do
      let(:new_user) { { email: 'test@test.org', password: '123456' } }

      it 'returns forbidden' do
        authenticate_user(user)
        create_call(new_user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4103' do
        authenticate_user(user)
        create_call(new_user)
        expect(JSON.parse(response.body)['error_code']).to be(4103)
      end

      it 'returns the error message' do
        authenticate_user(user)
        create_call(new_user)
        error_message = 'User cannot perform this action due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end

    context 'when params are invalid' do
      let(:new_user) { { email: 'test.org', password: '123456' } }

      it 'returns the error code 4104' do
        authenticate_user(admin)
        create_call(new_user)
        expect(JSON.parse(response.body)['error_code']).to be(4104)
      end

      it 'returns code 422' do
        authenticate_user(admin)
        create_call(new_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error' do
        authenticate_user(admin)
        create_call(new_user)
        expect(JSON.parse(response.body)['details']).to eql(['is not an email'])
      end
    end

    context 'when the email was taken by other user' do
      let(:new_user) { { email: user.email, password: '123456' } }

      it 'returns the error code 4106' do
        authenticate_user(admin)
        create_call(new_user)
        expect(JSON.parse(response.body)['error_code']).to be(4106)
      end

      it 'returns code 422' do
        authenticate_user(admin)
        create_call(new_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error' do
        authenticate_user(admin)
        create_call(new_user)
        expect(JSON.parse(response.body)['description']).to eql('The email is already in use')
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

    context 'when the user is admin and was authenticated' do
      it 'returns successful' do
        update_user_call(authenticated_admin)
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        update_user_call(authenticated_admin)
        expect(JSON.parse(response.body)['email']).to eql('email@dominio.com')
      end
    end

    context 'when params are invalid' do
      let(:user_params) { { email: 'bad_email', password: '123456' } }

      it 'returns a error' do
        update_user_call(authenticated_admin)
        expect(JSON.parse(response.body)['details']).to eql(['is not an email'])
      end

      it 'error status is 422' do
        update_user_call(authenticated_admin)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error code 4105' do
        update_user_call(authenticated_admin)
        expect(JSON.parse(response.body)['error_code']).to be(4105)
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

      it 'returns the error code 4107' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        update_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4107)
      end

      it 'returns the error message' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        update_user_call(user)
        error_message = 'Cannot perform this action over user due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end

    context 'when the email was taken by other user' do
      let(:user_params) { { email: user.email, password: admin.password } }

      it 'returns the error code 4106' do
        authenticate_user(admin)
        update_user_call(admin)
        expect(JSON.parse(response.body)['error_code']).to be(4106)
      end

      it 'returns code 422' do
        authenticate_user(admin)
        update_user_call(admin)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error' do
        authenticate_user(admin)
        update_user_call(admin)
        expect(JSON.parse(response.body)['description']).to eql('The email is already in use')
      end
    end

    context 'when user is not an admin' do
      it 'returns a error' do
        update_user_call(authenticated_user)
        error_message = 'User cannot perform this action due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'error status is forbidden' do
        update_user_call(authenticated_user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4103' do
        update_user_call(authenticated_user)
        expect(JSON.parse(response.body)['error_code']).to be(4103)
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_user_call(user_to_destroy)
      delete :destroy, params: { id: user_to_destroy.id }
    end

    context 'when the user is admin and was authenticated' do
      it 'returns no content' do
        authenticate_user(admin)
        delete_user_call(user)
        expect(response).to have_http_status(:no_content)
      end

      it 'destroy the user' do
        authenticate_user(admin)
        delete_user_call(user)
        expect(User.find_by(id: user.id).nil?).to be(true)
      end
    end

    context 'when the user is not admin' do
      it 'returns forbidden' do
        authenticate_user(user)
        delete_user_call(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4103' do
        authenticate_user(user)
        delete_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4103)
      end

      it 'returns the error message' do
        authenticate_user(user)
        delete_user_call(user)
        error_message = 'User cannot perform this action due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end

    context 'when headers are nil' do
      it 'returns unauthorized' do
        request.headers['Authorization'] = nil
        delete_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4107' do
        request.headers['Authorization'] = nil
        delete_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4107)
      end
    end

    context 'when token is invalid' do
      it 'returns unauthorized' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete_user_call(user)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4107' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete_user_call(user)
        expect(JSON.parse(response.body)['error_code']).to be(4107)
      end

      it 'returns the error message' do
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete_user_call(user)
        error_message = 'Cannot perform this action over user due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end
  end
end
