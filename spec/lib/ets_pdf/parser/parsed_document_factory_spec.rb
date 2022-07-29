# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Parser::ParsedDocumentFactory do
  let(:lines) do
    parsed_lines.map { SecureRandom.hex }
  end
  let(:parsed_lines) { matched_parsed_lines + build_list(:unparsed_line, 3) }
  let(:matched_parsed_lines) { build_list(:parsed_term_line, 3) }
  let(:document) { instance_double(EtsPdf::Parser::ParsedDocument) }

  before do
    lines.each_with_index do |line, index|
      allow(EtsPdf::Parser::ParsedLine).to receive(:new).with(line).and_return(parsed_lines[index])
    end
    allow(EtsPdf::Parser::ParsedDocument).to receive(:new).with(matched_parsed_lines).and_return(document)
  end

  describe "#call" do
    it "returns a parsed document for all parsed lines" do
      expect(described_class.call(lines)).to eq(document)
    end
  end
end
