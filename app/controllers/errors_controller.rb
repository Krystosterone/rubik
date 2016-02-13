class ErrorsController < ApplicationController
  MAPPED_ERRORS = Rack::Utils::SYMBOL_TO_STATUS_CODE.slice(
    :not_found,
    :unprocessable_entity,
    :internal_server_error
  )

  MAPPED_ERRORS.each do |status, code|
    define_method status do
      @status = status
      @code = code

      render "show", status: status
    end
  end
end
