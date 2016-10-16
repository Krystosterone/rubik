# frozen_string_literal: true
require "rails_helper"

describe "Sidekiq Authentication", type: :request do
  let(:permitted_user) { Rails.application.config.sidekiq_user_emails.first }
  before do
    OmniAuth.config.mock_auth[SidekiqAuthentication::AUTH_PROVIDER_NAME.to_sym] =
      OmniAuth::AuthHash.new("info" => { "email" => permitted_user })
  end
  after { OmniAuth.config.mock_auth[SidekiqAuthentication::AUTH_PROVIDER_NAME] = nil }

  it "redirects to the sidekiq root page" do
    get sidekiq_signin_path
    2.times { follow_redirect! }
    expect(response).to redirect_to(sidekiq_web_path)

    get sidekiq_signout_path
    expect(response).to redirect_to(root_path)
  end
end
