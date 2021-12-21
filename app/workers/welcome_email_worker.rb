# frozen_string_literal: true

class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform(user, admin)
    UserMailer.with(user_email: user.email, admin_email: admin.email).welcome_email.deliver_now
  end
end
