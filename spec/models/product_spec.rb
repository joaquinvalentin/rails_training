# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  price      :decimal(, )      not null
#  published  :boolean          default(FALSE)
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:user, :with_product).products.first }

  context 'when is created' do
    it 'will have a positive price' do
      product.price = -1
      expect(product.valid?).to be(false)
    end
  end
end
