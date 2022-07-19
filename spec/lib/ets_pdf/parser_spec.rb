# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Parser do
  describe ".call" do
    let(:actual_lines) { described_class.call(path) }
    let(:expected_lines) { File.readlines(path) }
    let(:path) { Rails.root.join("spec", "fixtures", "file.txt") }

    specify { expect(actual_lines.size).to eq(3) }

    it "returns the parsed lines from the file" do
      expected_lines.each_with_index do |line, index|
        expect(actual_lines[index].line.rstrip).to eq(line.rstrip)
      end
    end
  end
end
