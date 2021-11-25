# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_ids = []

admin = User.create!(
  email: 'admin@xl.com', password: 'password', admin: true
)
puts "Created a new admin: #{admin.email}"

5.times do
  user = User.create!(
    email: Faker::Internet.email, password: Faker::Internet.password
  )
  user_ids << user.id
  puts "Created a new user: #{user.email}"
end

5.times do
  product = Product.create!(
    title: Faker::Commerce.product_name,
    price: Faker::Commerce.price,
    user_id: user_ids.sample,
    published: true
  )
  puts "Created a brand new product: #{product.title}"
end
