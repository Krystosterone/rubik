# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Parser::ParsedLine::Base do
  describe SampleParsedLine do
    describe "#parsed?" do
      context "with an unparsed line" do
        subject { described_class.new("invalid line") }

        it { is_expected.not_to be_parsed }
      end

      context "with a parsed line" do
        subject { described_class.new("valid line") }

        it { is_expected.to be_parsed }
      end
    end
  end
end
