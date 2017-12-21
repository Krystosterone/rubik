# frozen_string_literal: true

require "rails_helper"

describe ScheduleWeekdaysHelper do
  describe "#schedule_weekday_collapsible??" do
    context "when it is empty" do
      let(:schedule_weekday) { instance_double(ScheduleWeekday, empty?: true) }

      specify { expect(helper.schedule_weekday_collapsible?(schedule_weekday)).to eq(true) }
    end

    context "when there are some periods" do
      let(:schedule_weekday) { instance_double(ScheduleWeekday, empty?: false) }

      specify { expect(helper.schedule_weekday_collapsible?(schedule_weekday)).to eq(false) }
    end
  end

  describe "#schedule_weekday_backdrop_class" do
    context "when the weekday is not a weekend" do
      let(:schedule_weekday) { instance_double(ScheduleWeekday, weekend?: false) }

      it "returns nothing" do
        expect(helper.schedule_weekday_backdrop_class(schedule_weekday)).to be_nil
      end
    end

    context "when the weekday is a weekend weekday" do
      let(:schedule_weekday) { instance_double(ScheduleWeekday, weekend?: true) }

      it "returns the backdrop class" do
        expect(helper.schedule_weekday_backdrop_class(schedule_weekday)).to eq("weekend")
      end
    end
  end

  describe "#schedule_weekday_css_class" do
    context "with a weekend weekday with index 0" do
      let(:schedule_weekday) { instance_double(ScheduleWeekday, index: 0, weekend?: true) }

      it "returns the css class" do
        expect(helper.schedule_weekday_css_class(schedule_weekday)).to eq("weekday-0 weekend")
      end
    end

    (1..3).each do |index|
      context "with a weekday of index #{index}" do
        let(:schedule_weekday) { instance_double(ScheduleWeekday, index: index, weekend?: false) }

        it "returns the css class" do
          expect(helper.schedule_weekday_css_class(schedule_weekday)).to eq("weekday-#{index}")
        end
      end
    end
  end

  describe "#schedule_weekday_name" do
    %w[Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi].each_with_index do |name, index|
      context "with an index #{index}" do
        let(:schedule_weekday) { instance_double(ScheduleWeekday, index: index) }

        it "returns the #{name}" do
          expect(helper.schedule_weekday_name(schedule_weekday)).to eq(name)
        end
      end
    end
  end
end
