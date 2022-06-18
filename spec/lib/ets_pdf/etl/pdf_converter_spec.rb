# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::PdfConverter do
  describe ".call" do
    let(:pdf_folder) { "tmp/pdf_directory" }
    let(:pdf_pattern) { "#{pdf_folder}/**/*" }

    before do
      (1..6).each { |index| FileUtils.mkdir_p(Rails.root.join(pdf_folder, "#{index}.pdf")) }
      (4..6).each { |index| FileUtils.mkdir_p(Rails.root.join(pdf_folder, "#{index}.txt")) }

      allow(Kernel).to receive(:system)
    end

    after { FileUtils.rm_rf(pdf_folder) }

    it "converts every pdf to txt" do
      described_class.call(pdf_pattern)

      (1..3).each do |index|
        pdf_path = Rails.root.join(pdf_folder, "#{index}.pdf").to_s
        expect(Kernel).to have_received(:system).with("pdftotext", "-enc", "UTF-8", "-layout", pdf_path)
      end
    end

    it "returns the argument" do
      expect(described_class.call(pdf_pattern)).to eq(pdf_pattern)
    end
  end
end
