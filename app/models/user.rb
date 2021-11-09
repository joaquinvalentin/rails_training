# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :email, uniqueness: true, email: true
  validates :password_digest, presence: true

  has_secure_password
end
