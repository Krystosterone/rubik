# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl do
  describe "#call" do
    let(:pdf_converter) { ->(value) { value + %w[pdf_converter] } }
    let(:pdf_parser) { ->(value) { value + %w[pdf_parser] } }
    let(:domain_builder) { ->(value) { value + %w[domain_builder] } }

    before do
      allow(EtsPdf::Etl::PdfConverter).to receive(:call, &pdf_converter)
      allow(EtsPdf::Etl::PdfParser).to receive(:call, &pdf_parser)
      allow(EtsPdf::Etl::DomainBuilder).to receive(:call, &domain_builder)
    end

    context "with no patterns" do
      subject(:etl) { described_class.new }

      it "executes in order each service" do
        expect(etl.call).to eq(
          Dir.glob(
            Rails.root.join("db", "raw", "ets", "**", "*.pdf")
          ).map(&:to_s) + %w[pdf_converter pdf_parser domain_builder]
        )
      end
    end

    context "with patterns" do
      subject(:etl) { described_class.new(patterns) }

      let(:patterns) { ["some/directory/**/*"] }

      it "executes in order each service" do
        expect(etl.call).to eq(patterns + %w[pdf_converter pdf_parser domain_builder])
      end
    end
  end
end
