# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    price { Faker::Commerce.price }
    published { true }
  end
end
