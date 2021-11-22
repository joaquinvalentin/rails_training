# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  def user
    @user ||= create(:user, :with_products)
  end

  describe 'GET #show' do
    def do_request(id)
      get :show, params: { id: id }
    end

    context 'when is successful' do
      it 'return successful' do
        do_request(user.products.first.id)
        expect(response).to have_http_status(:success)
      end

      it 'returns the product' do
        do_request(user.products.first.id)
        expect(JSON.parse(response.body)['title']).to eql(user.products.first.title)
      end
    end

    context 'when is not successful' do
      it 'returns not found' do
        do_request(0)
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        do_request(0)
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find Product with 'id'=0")
      end

      it 'returns the error code 4104' do
        do_request(0)
        expect(JSON.parse(response.body)['error_code']).to be(4104)
      end
    end
  end

  describe 'GET #index' do
    context 'when is successful' do
      def do_request
        get :index
      end

      it 'return successful' do
        do_request
        expect(response).to have_http_status(:success)
      end

      it 'returns the list of products' do
        title = user.products.first.title
        do_request
        expect(JSON.parse(response.body).first['title']).to eql(title)
      end
    end
  end

  describe 'POST #create' do
    def do_request(product)
      authenticate_user(user)
      post :create, params: product
    end

    context 'when is successful' do
      it 'returns the product' do
        do_request({ product: { title: 'New Product', price: 10 } })
        expect(JSON.parse(response.body)['title']).to eql('New Product')
      end
    end

    context 'when is not successful' do
      it 'returns the error message' do
        do_request({ product: { title: '', price: 10 } })
        expect(JSON.parse(response.body)['description']).to eql('Invalid parameter in product')
      end

      it 'returns bad request' do
        do_request({ product: { title: '', price: 10 } })
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the error code 4130' do
        do_request({ product: { title: '', price: 10 } })
        expect(JSON.parse(response.body)['error_code']).to be(4130)
      end
    end
  end

  describe 'PUT #update' do
    context 'when is successful' do
      def do_request(id, product)
        authenticate_user(user)
        put :update, params: { id: id, product: product }
      end

      it 'returns the product' do
        do_request(user.products.first.id, { title: 'New Product' })
        expect(JSON.parse(response.body)['title']).to eql('New Product')
      end
    end

    context 'when parameters are invalid' do
      def do_request
        authenticate_user(user)
        put :update, params: { id: user.products.first.id, product: { title: '' } }
      end

      it 'returns the error message' do
        do_request
        expect(JSON.parse(response.body)['description']).to eql('Invalid parameter in product')
      end

      it 'returns bad request' do
        do_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the error code 4130' do
        do_request
        expect(JSON.parse(response.body)['error_code']).to be(4130)
      end
    end

    context 'when user is not the owner' do
      def do_request
        other_user = create(:user, :with_products)
        other_product = other_user.products.first
        authenticate_user(user)
        put :update, params: { id: other_product.id, product: { title: 'New Product' } }
      end

      it 'returns the error message' do
        do_request
        message_expected = 'Product can not be deleted or updated due to being unauthorized'
        expect(JSON.parse(response.body)['description']).to eql(message_expected)
      end

      it 'returns unauthorized' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4111' do
        do_request
        expect(JSON.parse(response.body)['error_code']).to be(4111)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is successful' do
      def do_request
        authenticate_user(user)
        delete :destroy, params: { id: user.products.first.id }
      end

      it 'returns no content' do
        do_request
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when product does not exist' do
      def do_request
        authenticate_user(user)
        delete :destroy, params: { id: 0 }
      end

      it 'returns not found' do
        do_request
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        do_request
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find Product with 'id'=0")
      end

      it 'returns the error code 4104' do
        do_request
        expect(JSON.parse(response.body)['error_code']).to be(4104)
      end
    end

    context 'when user is not the owner' do
      def do_request
        other_user = create(:user, :with_products)
        other_product = other_user.products.first
        authenticate_user(user)
        delete :destroy, params: { id: other_product.id }
      end

      it 'returns the error message' do
        do_request
        message_expected = 'Product can not be deleted or updated due to being unauthorized'
        expect(JSON.parse(response.body)['description']).to eql(message_expected)
      end

      it 'returns unauthorized' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the error code 4111' do
        do_request
        expect(JSON.parse(response.body)['error_code']).to be(4111)
      end
    end
  end
end
