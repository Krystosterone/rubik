# frozen_string_literal: true
require "rails_helper"

describe SidekiqSessionsController do
  describe "#create" do
    context "when not passing through omniauth" do
      before { get :create }
      it { is_expected.to redirect_to(unauthorized_path) }
    end

    context "when the user is not permitted" do
      before do
        request.env["omniauth.auth"] = { "info" => { "email" => "not-allowed@mail.com" } }
        get :create
      end
      it { is_expected.to redirect_to(unauthorized_path) }
    end

    context "when the user is permitted" do
      let(:permitted_user) { Rails.application.config.sidekiq_user_emails.first }
      before do
        request.env["omniauth.auth"] = { "info" => { "email" => permitted_user } }
        get :create
      end

      specify { expect(session[SidekiqSession::NAME]).to eq(true) }
      it { is_expected.to redirect_to(sidekiq_web_path) }
    end
  end

  describe "#destroy" do
    before do
      session[SidekiqSession::NAME] = true
      get :destroy
    end

    specify { expect(session[SidekiqSession::NAME]).to eq(false) }
    it { is_expected.to redirect_to(root_path) }
  end
end
