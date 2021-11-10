# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'with taken email' do
    it 'will be invalid' do
      other_user = user
      user = described_class.new(email: other_user.email, password_digest:
      'test')
      expect(user.valid?).to be(false)
    end
  end
end
