# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  context 'with taken email' do
    it 'will be invalid' do
      other_user = users(:one)
      user = described_class.new(email: other_user.email, password_digest:
      'test')
      expect(user.valid?).to be(false)
    end
  end
end
