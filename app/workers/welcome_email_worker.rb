# frozen_string_literal: true

class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
  end
end
