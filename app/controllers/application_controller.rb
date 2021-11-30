# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticable
  include ErrorHandler
  include Pundit
end
