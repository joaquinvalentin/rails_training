# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferProduct, type: :service do
  def owner_user
    @owner_user ||= create(:user, :with_product)
  end

  def product
    @product ||= owner_user.products.first
  end

  def receiver_user
    @receiver_user ||= create(:user)
  end

  def admin
    @admin ||= create(:user, :is_admin)
  end

  def call_service(owner, target, product)
    TransferProduct.new(product: product, new_owner: target, current_owner: owner).call
  end

  context 'when the transfer is valid' do
    it 'will change the owner of the product' do
      call_service(owner_user, receiver_user, product)
      expect(product.user_id).to eql receiver_user.id
    end
  end

  context 'when the target is admin' do
    it 'returns status number 4208' do
      status = call_service(owner_user, admin, product)
      expect(status).to be 4208
    end

    it 'the transfer was not made' do
      call_service(owner_user, admin, product)
      expect(product.user_id).to eql owner_user.id
    end
  end

  context 'when the current user is not the owner' do
    def other_user
      @other_user ||= create(:user, :with_product)
    end

    it 'returns status number 4207' do
      status = call_service(other_user, admin, product)
      expect(status).to be 4207
    end

    it 'the transfer was not made' do
      call_service(other_user, admin, product)
      expect(product.user_id).to eql owner_user.id
    end
  end
end
