# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateUser, type: :service do
  def admin
    @admin ||= create(:user, :is_admin)
  end

  def call_service(creator, user_params)
    CreateUser.call(user_params: user_params, creator: creator)
  end

  context 'when the params are valid' do
    def params
      { email: 'prueba@gmail.com', password: 'P4ssw0rd', admin: 0 }
    end

    it 'will create the user' do
      create_user = call_service(admin, params)
      expect(create_user.user.email).to eql params[:email]
    end
  end

  context 'when the params are invalid' do
    def params
      { email: '[].com', password: 'P4ssw0rd', admin: 0 }
    end

    it 'returns an error' do
      create_user = call_service(admin, params)
      expect(create_user.error?).to be true
    end

    it 'returns the error code 4104' do
      create_user = call_service(admin, params)
      expect(create_user.error_code).to be 4104
    end

    it 'the user is not created' do
      call_service(admin, params)
      expect(User.find_by_email(params[:email])).to be nil
    end
  end
end
