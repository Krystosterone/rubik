require "rails_helper"

describe WeekdayTimeDecorator do
  describe "#time" do
    context "with minutes less than 10" do
      subject(:decorator) { described_class.new(weekday_time) }
      let(:weekday_time) { instance_double(WeekdayTime, hour: 5, minutes: 9) }

      it "returns a formatted time padded for minutes" do
        expect(decorator.time).to eq("5:09")
      end
    end

    context "with minutes equal or grater to 10" do
      subject(:decorator) { described_class.new(weekday_time) }
      let(:weekday_time) { instance_double(WeekdayTime, hour: 11, minutes: 34) }

      it "returns a formatted time" do
        expect(decorator.time).to eq("11:34")
      end
    end
  end
end
