require "rails_helper"

describe ScheduleDecorator do
  describe "#css_class" do
    subject { described_class.new(schedule) }
    let(:schedule) do
      instance_double(
        Schedule,
        starts_at: instance_double(WeekTime, hour: 10),
        ends_at: instance_double(WeekTime, hour: 24)
      )
    end

    context "when the weekend weekdays are collapsible" do
      let(:weekdays) do
        [
          ScheduleWeekday.new(index: 0, periods: []),
          *Array.new(5) { ScheduleWeekday.new(index: 1) },
          ScheduleWeekday.new(index: 0, periods: []),
        ]
      end
      before { allow(schedule).to receive(:weekdays).and_return(weekdays) }

      its(:css_class) { is_expected.to eq("from-600 duration-780 collapsible") }
    end

    context "when not all weekend weekdays are collapsible" do
      let(:weekdays) do
        [
          ScheduleWeekday.new(index: 0, periods: []),
          *Array.new(5) { ScheduleWeekday.new(index: 1) },
          ScheduleWeekday.new(index: 0, periods: [Period.new]),
        ]
      end
      before { allow(schedule).to receive(:weekdays).and_return(weekdays) }

      its(:css_class) { is_expected.to eq("from-600 duration-780") }
    end
  end

  describe "#hours" do
    context "when the starting hour is 12" do
      subject(:decorator) { described_class.new(schedule) }
      let(:schedule) { instance_double(Schedule, starts_at: instance_double(WeekTime, hour: 12)) }

      context "when the end hour is 14" do
        before { allow(schedule).to receive(:ends_at).and_return(instance_double(WeekTime, hour: 14)) }

        it "ranges from 12:00 to 14:00" do
          expect(decorator.hours).to eq(%w(12:00 13:00 14:00))
        end
      end

      context "when the end hour is 24" do
        before { allow(schedule).to receive(:ends_at).and_return(instance_double(WeekTime, hour: 24)) }

        it "ranges from 12:00 to 23:00" do
          expect(decorator.hours).to eq(%w(
            12:00 13:00 14:00 15:00
            16:00 17:00 18:00 19:00
            20:00 21:00 22:00 23:00
          ))
        end
      end
    end
  end
end
