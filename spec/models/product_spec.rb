# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:user_with_products).products.first }

  context 'when is created' do
    it 'will have a positive price' do
      product.price = -1
      expect(product.valid?).to be(false)
    end
  end
end
