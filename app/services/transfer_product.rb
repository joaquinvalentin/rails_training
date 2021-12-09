# frozen_string_literal: true

class TransferProduct < ServiceObject
  def initialize(product:, current_owner:, new_owner:)
    @product = product
    @new_owner = new_owner
    @current_owner = current_owner
  end

  def call
    return @error = 4207 unless ProductPolicy.new(current_owner, product).transfer_from?
    return @error = 4208 unless ProductPolicy.new(new_owner, product).transfer_to?

    transfer_product
  end

  private

  attr_reader :new_owner, :product, :current_owner

  def transfer_product
    product.user_id = new_owner.id
    product.save!
  end

  def object
    @object ||= Object.find(@first_param)
  end
end
