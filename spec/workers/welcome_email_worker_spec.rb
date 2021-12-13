# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe WelcomeEmailWorker, type: :worker do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :is_admin) }

  describe 'testing worker' do
    it 'WelcomeEmailWorker jobs are enqueued in the scheduled queue' do
      described_class.perform_async
      expect(described_class.queue).equal?(:default)
    end

    it 'goes into the jobs array for testing environment' do
      expect do
        described_class.perform_async
      end.to change(described_class.jobs, :size).by(1)
    end
  end
end
