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
end
