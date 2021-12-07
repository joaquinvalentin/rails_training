# frozen_string_literal: true

require 'letter_opener'

LetterOpener.configure do |config|
  # Default value is `:default` that renders styled message with showing useful metadata.
  config.message_template = :default
  # config.message_template = :light
end
