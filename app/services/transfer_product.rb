# frozen_string_literal: true

class TransferProduct < ServiceObject
  def initialize(product:, new_owner:)
    super
    @product = product
    @new_owner = new_owner
  end

  def call
    transfer_product
  end

  private

  attr_reader :new_owner, :product

  def transfer_product
    product.user_id = new_owner.id
    product.save!
  end

  def object
    @object ||= Object.find(@first_param)
  end
end
