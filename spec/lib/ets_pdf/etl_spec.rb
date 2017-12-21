# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl do
  describe "#call" do
    subject(:etl) { described_class.new("some/directory/**/*") }

    let(:pdf_converter) { ->(value) { "#{value}+pdf_converter" } }
    let(:pdf_parser) { ->(value) { "#{value}+pdf_parser" } }
    let(:domain_builder) { ->(value) { "#{value}+domain_builder" } }

    before do
      allow(EtsPdf::Etl::PdfConverter).to receive(:call, &pdf_converter)
      allow(EtsPdf::Etl::PdfParser).to receive(:call, &pdf_parser)
      allow(EtsPdf::Etl::DomainBuilder).to receive(:call, &domain_builder)
    end

    it "executes in order each service" do
      expect(etl.call).to eq("some/directory/**/*+pdf_converter+pdf_parser+domain_builder")
    end
  end
end
