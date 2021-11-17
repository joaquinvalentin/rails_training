# frozen_string_literal: true

require 'rails_helper'
require 'json'

class MockController
  include Authenticable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe Authenticable, type: :controller do
  let(:user) { create(:user) }
  let(:authentication) { MockController.new }

  describe '#current_user' do
    context 'when the header is present' do
      it 'returns the user' do
        authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
        expect(authentication.current_user.id).to eq(user.id)
      end
    end

    context 'when the header is not present' do
      it 'returns nil' do
        authentication.request.headers['Authorization'] = nil
        expect(authentication.current_user.nil?).to be(true)
      end
    end
  end
end
