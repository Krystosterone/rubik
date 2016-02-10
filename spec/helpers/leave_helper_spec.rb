require "rails_helper"

describe LeaveHelper do
  describe '#leave_times' do
    let(:result) do
      leaves = Array.new(7) do |day|
        (0..23).collect { |hour| WeekTime.on(day, hour) }
      end
      leaves.flatten
    end

    it "returns decorated week times for 0 to 23 hours for all the days of the weeks" do
      expect(leave_times).to eq(result)
      expect(leave_times).to be_decorated
    end
  end
end
