# frozen_string_literal: true

require "rails_helper"

describe TrimestersHelper do
  describe "#trimesters_list" do
    context "with only one trimester" do
      let(:trimesters) { ["One"] }

      it "returns the correct output" do
        expect(helper.trimesters_list(trimesters)).to eq("  - One")
      end
    end

    context "with many trimesters" do
      let(:trimesters) { %w[One Two Many] }

      it "returns the correct output" do
        expect(helper.trimesters_list(trimesters)).to eq("  1. One\n  2. Two\n  3. Many")
      end
    end
  end

  describe "#trimester_name" do
    context "with a term having tags" do
      let(:term) { build(:term, tags: nil) }

      it "returns the correct output" do
        expect(helper.trimester_name(term)).to eq("#{term.name} #{term.year}")
      end
    end

    context "with a term with no tags" do
      let(:term) { build(:term, tags: "woot") }

      it "returns the correct output" do
        expect(helper.trimester_name(term)).to eq("#{term.name} #{term.year} - woot")
      end
    end
  end
end
