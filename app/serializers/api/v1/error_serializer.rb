# frozen_string_literal: true

class Api::V1::ErrorSerializer < Blueprinter::Base
  fields :description, :error_code, :http_status

  field :details, if: ->(_field_name, error, _options) { error[:details].present? }
end
