# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::PdfParser do
  describe ".call" do
    let(:buffer) { instance_double(IO) }
    let(:txt_paths) do
      3.times.map { SecureRandom.hex }
    end
    let(:lines) do
      txt_paths.map do
        2.times.map { SecureRandom.hex }
      end
    end
    let(:documents) { build_list(:parsed_document, lines.size) }

    before do
      txt_paths.each_with_index do |txt_path, index|
        allow(buffer).to receive(:readlines).with(txt_path).and_return(lines[index])
        allow(EtsPdf::Parser::ParsedDocumentFactory)
          .to receive(:call).with(lines[index]).and_return(documents[index])
      end
    end

    it "creates parsed documents for all files" do
      expect(described_class.call(txt_paths, buffer)).to eq(documents)
    end
  end
end
