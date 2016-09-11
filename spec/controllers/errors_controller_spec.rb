# frozen_string_literal: true
require "rails_helper"

describe ErrorsController do
  ErrorsController::MAPPED_ERRORS.each do |status, code|
    describe "##{status}" do
      before { get status }

      specify { expect(response).to render_template("show") }
      specify { expect(response).to have_http_status(code) }

      specify { expect(assigns(:status)).to eq(status) }
      specify { expect(assigns(:code)).to eq(code) }
    end
  end
end
