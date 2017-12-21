# frozen_string_literal: true

class EtsPdf::Etl::PdfConverter < SimpleClosure
  PDF_EXTENSION = ".pdf"

  def initialize(pdf_pattern)
    @pdf_pattern = pdf_pattern
  end

  def call
    convert
    @pdf_pattern
  end

  private

  def convert
    Dir.glob(pdfs_path).each do |pdf_path|
      next if txt_exists?(pdf_path)
      Kernel.system("pdftotext", "-enc", "UTF-8", "-layout", pdf_path)
    end
  end

  def pdfs_path
    Rails.root.join("#{@pdf_pattern}#{PDF_EXTENSION}")
  end

  def txt_exists?(pdf_path)
    txt_path = File.dirname(pdf_path) + "/" + File.basename(pdf_path, ".*")
    File.exist?("#{txt_path}.txt")
  end
end
