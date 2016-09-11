require "rails_helper"

describe ScheduleWeekdayDecorator do
  describe "#periods" do
    subject(:decorator) { described_class.new(schedule_weekday) }
    let(:schedule_weekday) { build(:schedule_weekday) }

    specify { expect(decorator.periods).to be_decorated }
    specify { expect(decorator.periods).to eq(schedule_weekday.periods) }
  end

  describe "#collapsible?" do
    context "when it is empty" do
      subject(:decorator) { described_class.new(schedule_weekday) }
      let(:schedule_weekday) { instance_double(ScheduleWeekday, empty?: true) }

      specify { expect(decorator).to be_collapsible }
    end

    context "when there are some periods" do
      subject(:decorator) { described_class.new(schedule_weekday) }
      let(:schedule_weekday) { instance_double(ScheduleWeekday, empty?: false) }

      specify { expect(decorator).not_to be_collapsible }
    end
  end

  describe "#backdrop_class" do
    context "when the weekday is not a weekend" do
      subject(:decorator) { described_class.new(schedule_weekday) }
      let(:schedule_weekday) { instance_double(ScheduleWeekday, weekend?: false) }

      it "returns nothing" do
        expect(decorator.backdrop_class).to be_nil
      end
    end

    context "when the weekday is a weekend weekday" do
      subject(:decorator) { described_class.new(schedule_weekday) }
      let(:schedule_weekday) { instance_double(ScheduleWeekday, weekend?: true) }

      it "returns the backdrop class" do
        expect(decorator.backdrop_class).to eq("weekend")
      end
    end
  end

  describe "#css_class" do
    context "for a weekend weekday with index 0" do
      subject { described_class.new(schedule_weekday) }
      let(:schedule_weekday) { instance_double(ScheduleWeekday, index: 0, weekend?: true) }

      its(:css_class) { is_expected.to eq("weekday-0 weekend") }
    end

    (1..3).each do |index|
      context "for weekday of index #{index}" do
        subject { described_class.new(schedule_weekday) }
        let(:schedule_weekday) { instance_double(ScheduleWeekday, index: index, weekend?: false) }

        its(:css_class) { is_expected.to eq("weekday-#{index}") }
      end
    end
  end

  describe "#name" do
    %w(Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi).each_with_index do |name, index|
      context "for index #{index}" do
        subject(:decorator) { described_class.new(schedule_weekday) }
        let(:schedule_weekday) { instance_double(ScheduleWeekday, index: index) }

        it "returns the #{name}" do
          expect(decorator.name).to eq(name)
        end
      end
    end
  end
end
