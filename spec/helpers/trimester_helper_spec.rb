# frozen_string_literal: true
require "rails_helper"

describe TrimesterHelper do
  describe "#trimesters_list" do
    context "with only one trimester" do
      before { assign(:trimesters, ["One"]) }

      it "returns the correct output" do
        expect(helper.trimesters_list).to eq("  - One")
      end
    end

    context "with many trimesters" do
      before { assign(:trimesters, %w(One Two Many)) }

      it "returns the correct output" do
        expect(helper.trimesters_list).to eq("  1. One\n  2. Two\n  3. Many")
      end
    end
  end
end
