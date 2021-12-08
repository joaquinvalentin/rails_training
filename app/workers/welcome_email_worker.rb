# frozen_string_literal: true

class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform(user, admin)
    UserMailer.with(user: user, admin: admin).welcome_email.deliver_now
  end
end
