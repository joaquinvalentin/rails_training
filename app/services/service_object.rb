# frozen_string_literal: true

class ServiceObject
  class << self
    def call(*args)
      service = new(*args)
      service.call
      service
    end
  end

  attr_reader :status, :result, :exceptions, :error_code, :error_details

  def success?
    @status == :success
  end

  def error?
    @status == :error
  end

  def exception?
    @status == :exception
  end
end
