# frozen_string_literal: true
require "rails_helper"

describe Pipe do
  class PipeSpecStep < SimpleClosure
    def initialize(value)
      @value = value
    end

    protected

    attr_reader :value
  end

  class First < PipeSpecStep
    def call
      value + "\nfirst_output"
    end
  end

  class Last < PipeSpecStep
    def call
      value + "\nlast_output"
    end
  end

  describe "#call" do
    subject(:pipeline) do
      described_class.bind(First).bind(Last)
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
