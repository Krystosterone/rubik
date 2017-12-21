# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :show_navigation

  MAPPED_ERRORS = Rack::Utils::SYMBOL_TO_STATUS_CODE.slice(
    :internal_server_error,
    :not_found,
    :unauthorized,
    :unprocessable_entity
  )

  MAPPED_ERRORS.each do |status, code|
    define_method status do
      @status = status
      @code = code

      render "show", status: status
    end
  end
end
