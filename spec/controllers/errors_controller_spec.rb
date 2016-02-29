require "rails_helper"

describe ErrorsController do
  ErrorsController::MAPPED_ERRORS.each do |status, code|
    describe "##{status}" do
      before { get status }

      it "renders template with correct status code" do
        expect(response).to render_template("show")
        expect(response).to have_http_status(code)
      end

      it "assigns variables" do
        expect(assigns(:status)).to eq(status)
        expect(assigns(:code)).to eq(code)
      end
    end
  end
end
