# frozen_string_literal: true

require "rails_helper"

describe SchedulePaginationHelper do
  describe "#schedule_page_index" do
    let(:agenda) { build(:combined_agenda, schedules: build_list(:schedule, 50)) }
    let(:schedules) { agenda.schedules.page(3).per(SchedulePaginationHelper::SCHEDULES_PER_PAGE) }

    it "returns the schedule page index" do
      expect(schedule_page_index(schedules)).to eq(40)
    end
  end

  describe "#schedule_index" do
    let(:params) { ActionController::Parameters.new(index: "5") }

    it "returns the schedule index" do
      expect(schedule_index).to eq(4)
    end
  end

  describe "#schedule_page" do
    let(:params) { ActionController::Parameters.new(index: "163") }

    it "returns the schedule index" do
      expect(schedule_page).to eq(9)
    end
  end
end
