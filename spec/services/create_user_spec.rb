# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateUser, type: :service do
  def params
    { email: 'prueba@gmail.com', password: 'P4ssw0rd', admin: 0 }
  end

  def admin
    @admin ||= create(:user, :is_admin)
  end

  def service
    @service = CreateUser
  end

  def call_service(creator, user_params)
    service.call(user_params: user_params, creator: creator)
  end

  context 'when the params are valid' do
    it 'will create the user' do
      call_service(admin, params)
      expect(service.user.email).to eql params.email
    end
  end
end
