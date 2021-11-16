# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:user) { create(:user_with_products) }
  let(:product) { user.products.first }

  describe 'GET #show' do
    context 'when is successful' do
      before { get :show, params: { id: product.id } }

      it 'return successful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the product' do
        expect(JSON.parse(response.body)['title']).to eql(product.title)
      end
    end

    context 'when is not successful' do
      before { get :show, params: { id: 0 } }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find Product with 'id'=0")
      end
    end
  end

  describe 'GET #index' do
    context 'when is successful' do
      let(:products) { user.products }

      before do
        # If I remove this line, the test will fail
        user.products

        get :index
      end

      it 'return successful' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the list of products' do
        expect(JSON.parse(response.body).first['title']).to eql(products.first.title)
      end
    end
  end

  describe 'POST #create' do
    context 'when is successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before do
        request.headers.merge! headers
        post :create, params: { product: { title: 'New Product', price: 10 } }
      end

      it 'returns the product' do
        expect(JSON.parse(response.body)['title']).to eql('New Product')
      end
    end

    context 'when is not successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before do
        request.headers.merge! headers
        post :create, params: { product: { title: '', price: 10 } }
      end

      it 'returns the error message' do
        expect(JSON.parse(response.body)['description']).to eql('Invalid parameter in product')
      end

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT #update' do
    context 'when is successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before do
        request.headers.merge! headers
        put :update, params: { id: product.id, product: { title: 'New Product' } }
      end

      it 'returns the product' do
        expect(JSON.parse(response.body)['title']).to eql('New Product')
      end
    end

    context 'when is not successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before do
        request.headers.merge! headers
        put :update, params: { id: product.id, product: { title: '' } }
      end

      it 'returns the error message' do
        expect(JSON.parse(response.body)['description']).to eql('Invalid parameter in product')
      end

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before do
        request.headers.merge! headers
        delete :destroy, params: { id: product.id }
      end

      it 'returns no content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when is not successful' do
      let(:headers) do
        { 'Authorization': JsonWebToken.encode(user_id: user.id) }
      end

      before do
        request.headers.merge! headers
        delete :destroy, params: { id: 0 }
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message' do
        expect(JSON.parse(response.body)['details']).to eql("Couldn't find Product with 'id'=0")
      end
    end
  end
end
