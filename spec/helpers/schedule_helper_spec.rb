require "rails_helper"

describe ScheduleHelper do
  describe "#schedule_page_index" do
    before { @schedules = double("Schedules", current_page: 3, limit_value: 50) }

    it "returns the schedule page index" do
      expect(schedule_page_index).to eq(100)
    end
  end

  describe "#schedule_index" do
    let(:params) { ActionController::Parameters.new(index: "5") }

    it "returns the schedule index" do
      expect(schedule_index).to eq(4)
    end
  end
end
