# frozen_string_literal: true
class EtsPdf::Etl::Extract < SimpleClosure
  TXT_EXTENSION = ".txt"

  def initialize(txt_folder)
    @txt_folder = txt_folder
  end

  def call
    terms = {}
    Dir.glob(txt_paths).each do |txt_path|
      parsed_lines = EtsPdf::Parser.new(txt_path).execute
      assign_to_hash(terms, txt_path, parsed_lines)
    end
    terms
  end

  private

  def txt_paths
    Rails.root.join("#{@txt_folder}#{TXT_EXTENSION}")
  end

  def assign_to_hash(terms, path, parsed_lines)
    year, term_handle, type, bachelor_handle = parts_for(path)

    terms[year] ||= {}
    terms[year][term_handle] ||= {}
    terms[year][term_handle][type] ||= {}
    terms[year][term_handle][type][bachelor_handle] = parsed_lines
  end

  def parts_for(path)
    3.downto(0).collect { |up| part_of(path, up) }
  end

  def part_of(path, up)
    backwards_path = Array.new(up) { ".." }.join("/")
    File.basename(File.expand_path(backwards_path, path), TXT_EXTENSION)
  end
end
