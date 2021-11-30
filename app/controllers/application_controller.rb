# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticable
  include ErrorHandler
  include Pundit
  skip_before_action :verify_authenticity_token
end
