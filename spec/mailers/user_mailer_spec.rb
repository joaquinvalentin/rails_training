# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :is_admin) }
  let(:mail) { described_class.with(user: user, admin: admin.email).welcome_email }

  it 'correct subject' do
    expect(mail.subject).to eq('Welcome to My Awesome Site')
  end

  it 'correct destinatary' do
    expect(mail.to).to eq([user.email])
  end

  it 'correct sender' do
    expect(mail.from).to eq([admin.email])
  end
end
