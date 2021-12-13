# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  def user
    @user ||= create_auth_user_with_prod
  end

  def admin
    @admin ||= create_authenticated_admin
  end

  describe 'GET #show' do
    def make_request(id)
      get :show, params: { id: id }
    end

    context 'when the user has permissions' do
      it 'return successful' do
        make_request(user.products.first.id)
        expect(response).to have_http_status(:success)
      end

      it 'returns the product' do
        make_request(user.products.first.id)
        expect(JSON.parse(response.body)['title']).to eql(user.products.first.title)
      end
    end

    context 'when the product does not exist' do
      it 'returns not found' do
        authenticate_user(user)
        make_request(0)
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        authenticate_user(user)
        make_request(0)
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find Product with 'id'=0")
      end

      it 'returns the error code 4202' do
        authenticate_user(user)
        make_request(0)
        expect(JSON.parse(response.body)['error_code']).to be(4202)
      end
    end

    context 'when the user does not have permissions' do
      it 'returns forbidden' do
        id = user.products.first.id
        authenticate_user(admin)
        make_request(id)
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4205' do
        id = user.products.first.id
        authenticate_user(admin)
        make_request(id)
        expect(JSON.parse(response.body)['error_code']).to be(4205)
      end

      it 'returns an error message' do
        id = user.products.first.id
        authenticate_user(admin)
        make_request(id)
        error_message = 'Cannot perform this action over product due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end

    context 'when the user is not logged' do
      def do_call
        id = user.products.first.id
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        make_request(id)
      end

      it 'return unauthorized' do
        do_call
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error message ' do
        do_call
        error_message = 'Cannot perform this action over product due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4107' do
        do_call
        expect(JSON.parse(response.body)['error_code']).to be(4204)
      end
    end
  end

  describe 'GET #index' do
    context 'when is successful' do
      def make_request
        authenticate_user(user)
        get :index
      end

      it 'return successful' do
        make_request
        expect(response).to have_http_status(:success)
      end

      it 'returns the list of products' do
        make_request
        title = user.products.first.title
        expect(JSON.parse(response.body).first['title']).to eql(title)
      end

      it 'returns the total of pages' do
        make_request
        expect(response.headers['X-total-pages']).to be(1)
      end

      it 'returns the total per page' do
        make_request
        expect(response.headers['X-per-page']).to be(10)
      end

      it 'returns the total of products' do
        make_request
        expect(response.headers['X-total-entities']).to be(1)
      end

      it 'the number of products retrieved is less than X-per-pages' do
        make_request
        cant_prods = JSON.parse(response.body).count
        expect(response.headers['X-per-page']).to be >= cant_prods
      end
    end

    context 'when the user does not have permissions' do
      def make_request
        authenticate_user(admin)
        get :index
      end

      it 'returns forbidden' do
        make_request
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4205' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4205)
      end

      it 'returns an error message' do
        make_request
        error_message = 'Cannot perform this action over product due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end
    end

    context 'when the user is not logged' do
      def make_request
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        get :index
      end

      it 'return unauthorized' do
        make_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error message ' do
        make_request
        error_message = 'Cannot perform this action over product due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4107' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4204)
      end
    end
  end

  describe 'POST #create' do
    def make_request(product)
      authenticate_user(user)
      post :create, params: product
    end

    context 'when is successful' do
      it 'returns the product' do
        make_request({ product: { title: 'New Product', price: 10 } })
        expect(JSON.parse(response.body)['title']).to eql('New Product')
      end
    end

    context 'when is not successful' do
      it 'returns the error message' do
        make_request({ product: { title: '', price: 10 } })
        expect(JSON.parse(response.body)['description']).to eql('Product can not be created due to bad request')
      end

      it 'returns bad request' do
        make_request({ product: { title: '', price: 10 } })
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the error code 4200' do
        make_request({ product: { title: '', price: 10 } })
        expect(JSON.parse(response.body)['error_code']).to be(4200)
      end
    end

    context 'when the user is not logged' do
      def make_call
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        post :create, params: { product: { title: 'New Product', price: 10 } }
      end

      it 'return unauthorized' do
        make_call
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error message ' do
        make_call
        error_message = 'Cannot perform this action over product due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4107' do
        make_call
        expect(JSON.parse(response.body)['error_code']).to be(4204)
      end
    end
  end

  describe 'PUT #update' do
    context 'when is successful' do
      def make_request(id, product)
        authenticate_user(user)
        put :update, params: { id: id, product: product }
      end

      it 'returns the product' do
        make_request(user.products.first.id, { title: 'New Product' })
        expect(JSON.parse(response.body)['title']).to eql('New Product')
      end
    end

    context 'when parameters are invalid' do
      def make_request
        authenticate_user(user)
        put :update, params: { id: user.products.first.id, product: { title: '' } }
      end

      it 'returns the error message' do
        make_request
        expect(JSON.parse(response.body)['description']).to eql('Product can not be updated due to bad request')
      end

      it 'returns bad request' do
        make_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the error code 4201' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4201)
      end
    end

    context 'when user is not the owner' do
      def make_request
        other_product = create(:user, :with_product).products.first
        authenticate_user(user)
        put :update, params: { id: other_product.id, product: { title: 'New Product' } }
      end

      it 'returns the error message' do
        make_request
        message_expected = 'Product can not be updated due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(message_expected)
      end

      it 'returns forbidden' do
        make_request
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4203' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4203)
      end
    end

    context 'when the user is not logged' do
      def make_call
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        put :update, params: { id: 1, product: { title: 'New Product', price: 10 } }
      end

      it 'return unauthorized' do
        make_call
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error message ' do
        make_call
        error_message = 'Cannot perform this action over product due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4107' do
        make_call
        expect(JSON.parse(response.body)['error_code']).to be(4204)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is successful' do
      def make_request
        authenticate_user(user)
        delete :destroy, params: { id: user.products.first.id }
      end

      it 'returns no content' do
        make_request
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when product does not exist' do
      def make_request
        authenticate_user(user)
        delete :destroy, params: { id: 0 }
      end

      it 'returns not found' do
        make_request
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        make_request
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find Product with 'id'=0")
      end

      it 'returns the error code 4202' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4202)
      end
    end

    context 'when user is not the owner' do
      def make_request
        other_user = create(:user, :with_product)
        other_product = other_user.products.first
        authenticate_user(user)
        delete :destroy, params: { id: other_product.id }
      end

      it 'returns the error message' do
        make_request
        message_expected = 'Product can not be deleted due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(message_expected)
      end

      it 'returns unauthorized' do
        make_request
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4206' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4206)
      end
    end

    context 'when the user is not logged' do
      def make_request
        request.headers['Authorization'] = 'Bearer sdklhjflasgd'
        delete :destroy, params: { id: 0 }
      end

      it 'return unauthorized' do
        make_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error message ' do
        make_request
        error_message = 'Cannot perform this action over product due to unauthenticated request'
        expect(JSON.parse(response.body)['description']).to eql(error_message)
      end

      it 'returns the error code 4107' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4204)
      end
    end
  end

  describe 'POST #transfer' do
    def target_user
      @target_user ||= create(:user)
    end

    def make_request(product, target_email)
      authenticate_user(user)
      post :transfer, params: { id: product, email: target_email }
    end

    context 'when is successful' do
      it 'returns the product of the target user' do
        make_request(user.products.first.id, target_user.email)
        expect(JSON.parse(response.body)['user_id']).to eql(target_user.products.first.user_id)
      end
    end

    context 'when product is invalid' do
      it 'returns the error code 4207' do
        prod = create(:user, :with_product).products.first
        make_request(prod.id, target_user.email)
        expect(JSON.parse(response.body)['error_code']).to be(4207)
      end

      it 'return forbidden' do
        prod = create(:user, :with_product).products.first
        make_request(prod.id, target_user.email)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when target user is admin' do
      it 'returns the error code 4208' do
        make_request(user.products.first, admin.email)
        expect(JSON.parse(response.body)['error_code']).to be(4208)
      end

      it 'return unprocessable entity' do
        make_request(user.products.first, admin.email)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when target user is invalid' do
      it 'returns the error code 4209' do
        make_request(user.products.first, 'lfkjdsakl@email.com')
        expect(JSON.parse(response.body)['error_code']).to be(4209)
      end

      it 'return not found' do
        make_request(user.products.first, 'lfkjdsakl@email.com')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
