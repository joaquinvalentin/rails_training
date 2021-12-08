# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1.1'

# gem 'dotenv', '~> 2.7.6'
gem 'dotenv-rails', '~> 2.7.6'

# Use Rubocop for code quality
# gem 'rubocop', '~> 1.22.3'
gem 'rubocop', '~> 1.22.3', require: false

# User rspec for tests
gem 'rspec', '~> 3.10.0'

# Use Rubocop-rspec for code quality in tests
gem 'rubocop-rspec', '~> 2.5.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rswag-specs', '~> 2.4.0'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# For password hashing
gem 'bcrypt', '~> 3.1'

gem 'rspec-rails', '~> 5.0'

# For code coverage
gem 'simplecov', '~> 0.21.2', require: false, group: :test

# For create entities with factory_bot
group :development, :test do
  gem 'factory_bot_rails', '~> 6.2.0'
end

# For create fake data
gem 'faker', '~> 2.19.0', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'

gem 'jwt', '~> 2.3'

# For serialization

gem 'blueprinter', '~> 0.25.3'

group :test do
  gem 'database_cleaner-active_record', '~> 2.0.1'
end

group :development do
  gem 'annotate', '~> 3.1.1'
end

# For api documentation
gem 'rswag-api', '~> 2.4.0'
gem 'rswag-ui', '~> 2.4.0'

gem 'pundit', '~> 2.1.1'

gem 'activeadmin', '~> 2.9.0'

gem 'sass-rails', '~> 6.0.0'

gem 'devise', '~> 4.8.0'

gem 'kaminari'

gem 'letter_opener', group: :development

gem 'sidekiq', '~> 6.3.1'
