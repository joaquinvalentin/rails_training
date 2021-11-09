# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    record.errors.add 'error', 'is not an email' unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
