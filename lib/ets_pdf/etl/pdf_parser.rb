# frozen_string_literal: true

class EtsPdf::Etl::PdfParser < SimpleClosure
  TXT_EXTENSION = ".txt"

  def initialize(txt_folder)
    @txt_folder = txt_folder
  end

  def call
    Dir.glob(txt_paths).map(&method(:build))
  end

  private

  def build(path)
    year, term_handle, type, bachelor_handle = parts_for(path)
    parsed_lines = EtsPdf::Parser.call(path)

    {
      bachelor_handle: bachelor_handle,
      parsed_lines: parsed_lines,
      term_handle: term_handle,
      type: type,
      year: year,
    }
  end

  def parts_for(path)
    3.downto(0).collect { |up| part_of(path, up) }
  end

  def part_of(path, up)
    backwards_path = Array.new(up) { ".." }.join("/")
    File.basename(File.expand_path(backwards_path, path), TXT_EXTENSION)
  end

  def txt_paths
    Rails.root.join("#{@txt_folder}#{TXT_EXTENSION}")
  end
end
