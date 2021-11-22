# frozen_string_literal: true

require 'rails_helper'

shared_context 'with integration test' do
  run_test!
  after do |example|
    example.metadata[:response][:examples] =
      { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
  end
end

# https://github.com/rswag/rswag/issues/178
def document_response_without_test!
  before do |example|
    submit_request(example.metadata)
  end

  it 'adds documentation without testing the response' do |example|
    # Only check that the response is present
    expect(example.metadata[:response].present?).to be(true)
  end
end
