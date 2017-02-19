# frozen_string_literal: true
require "rails_helper"

describe "Sidekiq Authentication", type: :request do
  let(:permitted_user) { Rails.application.config.admin_emails.first }
  before { OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new("info" => { "email" => permitted_user }) }
  after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

  it "redirects to the sidekiq root page" do
    get admin_login_path
    2.times { follow_redirect! }
    expect(response).to redirect_to(admin_root_path)

    get admin_logout_path
    expect(response).to redirect_to(root_path)
  end
end
