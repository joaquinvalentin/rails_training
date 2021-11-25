# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  def user
    @user ||= create(:user, :with_products)
  end

  describe 'GET #show' do
    def make_request(id)
      get :show, params: { id: id }
    end

    context 'when is successful' do
      it 'return successful' do
        authenticate_user(user)
        make_request(user.products.first.id)
        expect(response).to have_http_status(:success)
      end

      it 'returns the product' do
        authenticate_user(user)
        make_request(user.products.first.id)
        expect(JSON.parse(response.body)['title']).to eql(user.products.first.title)
      end
    end

    context 'when is not successful' do
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
  end

  describe 'GET #index' do
    context 'when is successful' do
      def make_request
        get :index
      end

      it 'return successful' do
        authenticate_user(user)
        make_request
        expect(response).to have_http_status(:success)
      end

      it 'returns the list of products' do
        authenticate_user(user)
        title = user.products.first.title
        make_request
        expect(JSON.parse(response.body).first['title']).to eql(title)
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
        other_user = create(:user, :with_products)
        other_product = other_user.products.first
        authenticate_user(user)
        put :update, params: { id: other_product.id, product: { title: 'New Product' } }
      end

      it 'returns the error message' do
        make_request
        message_expected = 'Product can not be deleted or updated due to unauthorized request'
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
        other_user = create(:user, :with_products)
        other_product = other_user.products.first
        authenticate_user(user)
        delete :destroy, params: { id: other_product.id }
      end

      it 'returns the error message' do
        make_request
        message_expected = 'Product can not be deleted or updated due to unauthorized request'
        expect(JSON.parse(response.body)['description']).to eql(message_expected)
      end

      it 'returns unauthorized' do
        make_request
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the error code 4203' do
        make_request
        expect(JSON.parse(response.body)['error_code']).to be(4203)
      end
    end
  end
end
