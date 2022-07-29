# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Parser::ParsedDocument do
  subject(:parsed_document) { described_class.new(parsed_lines) }

  shared_examples "it returns a unique parsed line of" do |type:|
    method_name = "#{type}_line"

    context "with a supported type #{type}" do
      context "with mistmatching parsed lines" do
        let(:parsed_lines) { build_list("parsed_#{type}_line", 3) }

        it "raises an error" do
          expect { parsed_document.public_send(method_name) }
            .to raise_error(described_class::MismatchError, /Parsed lines of type #{type} are not unique/)
        end
      end

      context "with matching parsed lines" do
        let(:parsed_line) { build("parsed_#{type}_line") }
        let(:parsed_lines) do
          3.times.map { parsed_line }
        end

        it "returns one instance of the parsed line" do
          expect(parsed_document.public_send(method_name)).to eq(parsed_line.public_send(type))
        end
      end
    end
  end

  let(:parsed_lines) { build_list(:unparsed_line, 3) }

  its(:parsed_lines) { is_expected.to eq(parsed_lines) }

  describe "#empty?" do
    context "with no parsed lines" do
      let(:parsed_lines) { [] }

      it { is_expected.to be_empty }
    end

    context "with some parsed lines" do
      it { is_expected.not_to be_empty }
    end
  end

  it_behaves_like "it returns a unique parsed line of", type: "term"
  it_behaves_like "it returns a unique parsed line of", type: "bachelor"

  describe "#except" do
    let(:parsed_lines) do
      build_list(:parsed_term_line, 3) +
        more_parsed_lines
    end
    let(:more_parsed_lines) do
      build_list(:parsed_group_line, 3) +
        build_list(:parsed_period_line, 3)
    end

    it "returns a new document with all of the parsed lines except the specified type" do
      expect(parsed_document.except(:term).parsed_lines).to eq(more_parsed_lines)
    end
  end
end
