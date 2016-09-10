require "rails_helper"

describe EtsPdf::Parser do
  describe "#execute" do
    let(:lines) { %w(first_line second_line last_line) }
    let(:file_content) { lines.join("\n") + "\n" }
    let(:path) { Rails.root.join("tmp/file.txt") }
    subject { described_class.new(path) }
    before { File.write(path, file_content) }
    after { FileUtils.rm(path) }

    it "returns the parsed lines from the file" do
      parsed_lines = subject.execute

      expect(parsed_lines.size).to eq(3)
      lines.each_with_index do |line, index|
        expect(parsed_lines[index].line).to eq("#{line}\n")
      end
    end
  end
end
