# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::DomainBuilder do
  describe ".call" do
    let(:documents) do
      build_list(:parsed_document, 3) +
        [build(:parsed_document, parsed_lines: [])]
    end

    context "when some of the documents are empty" do
      it "raises an error" do
        expect { described_class.call(documents) }
          .to raise_error(ArgumentError, /At least one of the documents has no parsed lines/)
      end
    end

    context "when all documents are not empty" do
      let(:documents) { build_list(:parsed_document, 3) }

      before { allow(EtsPdf::Etl::TermBuilder).to receive(:call) }

      it "calls the term builder" do
        described_class.call(documents)

        expect(EtsPdf::Etl::TermBuilder).to have_received(:call).with(documents)
      end
    end
  end
end
