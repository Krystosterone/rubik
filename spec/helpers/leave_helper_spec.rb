# frozen_string_literal: true
require "rails_helper"

describe LeaveHelper do
  describe "#leave_times" do
    let(:result) do
      leaves = Array.new(7) do |day|
        (0..23).collect { |hour| WeekTime.on(day, hour) }
      end
      leaves.flatten
    end

    specify { expect(leave_times).to eq(result) }
  end
end
