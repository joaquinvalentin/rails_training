# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'usuario@xmartlabs.com' }
    password { '12345678' }
  end
end
