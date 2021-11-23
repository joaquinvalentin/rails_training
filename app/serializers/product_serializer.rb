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
class ProductSerializer < Blueprinter::Base
  field :id
  field :title
  field :price
  field :user_id
end
