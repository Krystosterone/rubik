# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Parser::ParsedLine::Base do
  class SampleParsedLine < EtsPdf::Parser::ParsedLine::Base
    private

    def match_pattern
      /^valid line/
    end
  end

  describe SampleParsedLine do
    describe "#parsed?" do
      context "for an unparsed line" do
        subject { described_class.new("invalid line") }
        it { is_expected.not_to be_parsed }
      end

      context "for a parsed line" do
        subject { described_class.new("valid line") }
        it { is_expected.to be_parsed }
      end
    end
  end
end
