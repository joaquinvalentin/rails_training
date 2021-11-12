# frozen_string_literal: true

# if User.count.zero?
5.times do
  User.create!(
    email: Faker::Internet.email, password: Faker::Internet.password
  )
end
# end
