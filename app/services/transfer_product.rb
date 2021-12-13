# frozen_string_literal: true

class TransferProduct < ServiceObject
  def initialize(*args)
    super()
    @product = args[0][:product]
    @new_owner = args[0][:new_owner]
    @current_owner = args[0][:current_owner]
    @error = false
  end

  def call
    @status = :error
    return @error_code = 4207 unless ProductPolicy.new(current_owner, product).transfer_from?
    return @error_code = 4208 unless ProductPolicy.new(new_owner, product).transfer_to?

    transfer_product
  end

  private

  attr_reader :new_owner, :product, :current_owner

  def transfer_product
    product.user_id = new_owner.id
    product.save!
    @status = :success
  end
end
