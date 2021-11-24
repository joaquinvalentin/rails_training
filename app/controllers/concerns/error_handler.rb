# frozen_string_literal: true

module ErrorHandler
  def render_error(error_code, details = {})
    render json: Api::V1::ErrorSerializer.render(
      Error.instance.error_for(error_code, details)
    ), status: Error.instance.http_status_for(error_code)
  end

  class AuthenticationError < StandardError
  end
end
