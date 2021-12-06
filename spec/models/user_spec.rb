# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin           :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  def user
    @user ||= create(:user)
  end

  def user_with_product
    @user_with_product ||= create(:user, :with_product)
  end

  context 'with taken email' do
    it 'will be invalid' do
      other_user = user
      user = described_class.new(email: other_user.email, password:
      'test')
      expect(user.valid?).to be(false)
    end
  end

  context 'when destroy' do
    it 'destroy linked product' do
      products = user_with_product.products
      user_with_product.destroy
      products.each do |product|
        expect(Product.find_by(id: product.id).nil?).to be(true)
      end
    end
  end
end
