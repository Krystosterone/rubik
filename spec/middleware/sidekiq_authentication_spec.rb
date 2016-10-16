# frozen_string_literal: true
require "rails_helper"

describe SidekiqAuthentication do
  include Rails.application.routes.url_helpers

  subject(:middleware) { described_class.new(app) }
  let(:app) { instance_double(Rubik::Application) }

  describe "#call" do
    context "when no sidekiq session is active" do
      let(:env) { {} }
      specify { expect(middleware.call(env)).to eq([302, { "Location" => sidekiq_signin_path }, []]) }
    end

    context "when a sidekiq session is active" do
      let(:env) { { "rack.session" => { SidekiqSession::NAME => true } } }

      it "calls through" do
        allow(app).to receive(:call).with(env)

        middleware.call(env)
      end
    end
  end
end
