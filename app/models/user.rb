# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ActiveRecord::Base
  validates :email, uniqueness: true, email: true
  validates :password_digest, presence: true

  has_secure_password

  has_many :products, dependent: :destroy
end
