require "rails_helper"

describe EtsPdf::Parser do
  describe "#execute" do
    subject(:parser) { described_class.new(path) }
    let(:lines) { %w(first_line second_line last_line) }
    let(:file_content) { lines.join("\n") + "\n" }
    let(:path) { Rails.root.join("tmp/file.txt") }
    let(:actual_lines) { parser.execute }

    before { File.write(path, file_content) }
    after { FileUtils.rm(path) }

    specify { expect(actual_lines.size).to eq(3) }

    it "returns the parsed lines from the file" do
      lines.each_with_index do |line, index|
        expect(actual_lines[index].line).to eq("#{line}\n")
      end
    end
  end
end
