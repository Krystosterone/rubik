# frozen_string_literal: true

class EtsPdf::Etl::PdfParser < SimpleClosure
  def initialize(txt_paths)
    super()
    @txt_paths = txt_paths
  end

  def call
    @txt_paths.map(&method(:build))
  end

  private

  def build(path)
    year, term_handle, bachelor_handle = parts_for(path)
    parsed_lines = EtsPdf::Parser.call(path)

    {
      bachelor_handle: bachelor_handle,
      parsed_lines: parsed_lines,
      term_handle: term_handle,
      year: year,
    }
  end

  def parts_for(path)
    2.downto(0).collect { |up_to| part_of(path, up_to) }
  end

  def part_of(path, up_to)
    backwards_path = Array.new(up_to) { ".." }.join("/")
    File.basename(File.expand_path(backwards_path, path), ".*")
  end
end
