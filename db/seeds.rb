# frozen_string_literal: true

if User.count.zero?
  100.times do
    User.create!(
      email: Faker::Internet.email, password: Faker::Internet.password
    )
  end
end
