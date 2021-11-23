# frozen_string_literal: true

class ProductSerializer < Blueprinter::Base
  field :id
  field :title
  field :price
  field :user_id
end
