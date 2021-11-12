# frozen_string_literal: true

require 'singleton'
require 'yaml'

class Error
  include Singleton

  def error_for(code, details)
    errors[code][:details] = details if details.present?
    errors[code]
  end

  def http_status_for(code)
    errors[code][:http_status]
  end

  private

  def errors
    @errors ||= YAML.load_file(Rails.root.join('config', 'errors.yaml'))
  end
end
