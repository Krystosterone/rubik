require "rails_helper"

describe WeekTime do
  it_behaves_like "WeekdayTime"

  describe ".on" do
    context "for day 2 with hour 22" do
      it "build the appropriate instance" do
        expect(described_class.on(2, 22))
          .to eq(described_class.new(4200))
      end
    end
  end

  describe "#hour" do
    context "for 2300 minutes" do
      subject { described_class.new(2300) }

      it "operates on a modulo 24" do
        expect(subject.hour).to eq(14)
      end
    end
  end

  describe "#weekday_index" do
    context "for 4500 minutes" do
      subject { described_class.new(4500) }
      its(:weekday_index) { is_expected.to eq(3) }
    end
  end
end
