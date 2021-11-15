# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { 'MyString' }
    price { '9.99' }
    published { false }
  end
end
