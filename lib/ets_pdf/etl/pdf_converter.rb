# frozen_string_literal: true

class EtsPdf::Etl::PdfConverter < SimpleClosure
  PDF_EXTENSION = ".pdf"
  TXT_EXTENSION = ".txt"

  def initialize(pdf_paths)
    super()
    @pdf_paths = pdf_paths
  end

  def call
    convert
    txt_paths
  end

  private

  def convert
    @pdf_paths.each do |pdf_path|
      next if File.exist?(txt_path(pdf_path))

      Kernel.system("pdftotext", "-enc", "UTF-8", "-layout", pdf_path)
    end
  end

  def txt_paths
    @pdf_paths.map { |pdf_path| txt_path(pdf_path) }
  end

  def txt_path(pdf_path)
    "#{File.dirname(pdf_path)}/#{File.basename(pdf_path, '.*')}#{TXT_EXTENSION}"
  end
end
