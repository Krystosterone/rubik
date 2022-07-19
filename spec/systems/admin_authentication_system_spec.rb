# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/MultipleExpectations
describe "Admin Authentication", type: :system do
  let(:permitted_user) { Rails.application.config.admin_emails.first }

  before do
    driven_by(:rack_test)

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new("info" => { "email" => permitted_user })
  end

  after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

  it "constraints admin routes" do
    expect { visit("/admin") }.to raise_error(ActionController::RoutingError)
    expect { visit("/admin/sidekiq") }.to raise_error(ActionController::RoutingError)

    login

    expect(page).to have_current_path(admin_sidekiq_web_path, ignore_query: true)
  end

  it "redirects to the admin root page" do
    login
    expect(page).to have_current_path(admin_sidekiq_web_path, ignore_query: true)

    visit "/admin/logout"
    expect(page).to have_current_path(root_path, ignore_query: true)
  end

  private

  def login
    visit "/admin/login"
    click_button "S'authentifier"
  end
end
# rubocop:enable RSpec/MultipleExpectations
