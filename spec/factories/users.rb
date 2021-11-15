# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    factory :user_with_products do
      after(:create) do |user|
        create(:product, user: user)
      end
    end
  end
end
