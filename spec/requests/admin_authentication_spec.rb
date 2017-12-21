# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
describe "Admin Authentication", type: :request do
  let(:permitted_user) { Rails.application.config.admin_emails.first }

  before { OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new("info" => { "email" => permitted_user }) }
  after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

  it "constraints admin routes" do
    expect { get admin_root_path }.to raise_error(ActionController::RoutingError)
    expect { get admin_sidekiq_web_path }.to raise_error(ActionController::RoutingError)

    login

    get admin_root_path
    expect(response).to redirect_to(admin_sidekiq_web_path)

    get admin_sidekiq_web_path
    expect(response).to have_http_status(:ok)
  end

  it "redirects to the admin root page" do
    login
    expect(response).to redirect_to(admin_root_path)

    get admin_logout_path
    expect(response).to redirect_to(root_path)
  end

  private

  def login
    get admin_login_path
    2.times { follow_redirect! }
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
