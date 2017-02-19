# frozen_string_literal: true
require "rails_helper"

describe AdminConstraint do
  subject(:contraint) { described_class.new }

  describe "#matches?" do
    context "when there is no admin session" do
      let(:request) { Rack::Request.new({}) }

      it "returns false" do
        expect(contraint.matches?(request)).to be_falsy
      end
    end

    context "when there is an admin session" do
      let(:request) { Rack::Request.new("rack.session" => { AdminSession::NAME => true }) }

      it "returns true" do
        expect(contraint.matches?(request)).to eq(true)
      end
    end
  end
end
