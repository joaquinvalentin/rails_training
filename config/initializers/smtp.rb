# frozen_string_literal: true

ActionMailer::Base.smtp_settings = {
  domain: Rails.application.config.domain,
  address: Rails.application.config.smtp_address,
  port: Rails.application.config.smtp_port,
  authentication: :plain,
  user_name: Rails.application.config.smtp_user_name,
  password: Rails.application.config.smtp_password
}
