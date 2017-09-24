# frozen_string_literal: true
require "rails_helper"

describe Pipe do
  describe "#call" do
    subject(:pipeline) do
      described_class
        .bind(->(value) { value + "\nfirst_output" })
        .bind(->(value) { value + "\nlast_output" })
    end
    let(:expected_output) do
      <<-OUTPUT.strip_heredoc.strip
        initial_input
        first_output
        last_output
      OUTPUT
    end

    it "executes every pipe in chain" do
      expect(pipeline.call("initial_input")).to eq(expected_output)
    end
  end
end
