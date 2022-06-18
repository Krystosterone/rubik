# frozen_string_literal: true

require "rails_helper"

describe Maintenance do
  subject(:middleware) { described_class.new(app) }

  let(:app) { instance_double(Rubik::Application) }

  describe "#call" do
    context "when maintenance mode is not enabled" do
      let(:env) { {} }

      it "calls through" do
        allow(app).to receive(:call).with(env)

        middleware.call(env)
      end
    end

    context "when maintenance mode is enabled" do
      let!(:maintenance_mode) { ENV.fetch("MAINTENANCE_MODE", nil) }

      before { ENV["MAINTENANCE_MODE"] = "1" }

      after { ENV["MAINTENANCE_MODE"] = maintenance_mode }

      context "when the maintainer ips do not include the request ip" do
        let(:env) { {} }
        let(:maintenance_page) { File.read(Rails.root.join("public", "maintenance.html")) }

        it "shows the maintenance page" do
          expect(middleware.call(env)).to eq([200, {}, [maintenance_page]])
        end
      end

      context "when the maintainer ips include the request ip" do
        let(:env) { { "REMOTE_ADDR" => "123.123.123.123" } }
        let!(:maintainer_ips) { ENV.fetch("MAINTAINER_IPS", nil) }

        before { ENV["MAINTAINER_IPS"] = "123.123.123.123" }

        after { ENV["MAINTAINER_IPS"] = maintainer_ips }

        it "calls through" do
          allow(app).to receive(:call).with(env)

          middleware.call(env)
        end
      end
    end
  end
end
