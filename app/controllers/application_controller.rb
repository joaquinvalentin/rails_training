# frozen_string_literal: true

class ApplicationController < ActionController::API
  def default_url_options
    if Rails.env.production?
      { host: 'example.com' }
    else
      { host: 'localhost:3000' }
    end
  end
end
