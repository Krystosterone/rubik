# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::PdfConverter do
  describe ".call" do
    let(:directory) { "tmp/pdf_directory" }
    let(:pdf_patterns) { (1..6).map { |index| Rails.root.join(directory, "#{index}.pdf").to_s } }
    let(:txt_patterns) { (1..6).map { |index| Rails.root.join(directory, "#{index}.txt").to_s } }

    before do
      (pdf_patterns + txt_patterns[4..-1]).each { |path| FileUtils.mkdir_p(path) }

      allow(Kernel).to receive(:system)
    end

    after { FileUtils.rm_rf(directory) }

    it "converts every pdf to txt" do
      described_class.call(pdf_patterns)

      pdf_patterns[0..2].each do |path|
        expect(Kernel).to have_received(:system).with("pdftotext", "-enc", "UTF-8", "-layout", path)
      end
    end

    it "returns the argument" do
      expect(described_class.call(pdf_patterns)).to eq(txt_patterns)
    end
  end
end
