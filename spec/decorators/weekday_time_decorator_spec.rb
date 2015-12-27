require 'rails_helper'

describe WeekdayTimeDecorator do
  describe '#time' do
    context 'with minutes less than 10' do
      let(:weekday_time) { double(WeekdayTime, hour: 5, minutes: 9) }
      subject { described_class.new(weekday_time) }

      it 'returns a formatted time padded for minutes' do
        expect(subject.time).to eq('5:09')
      end
    end

    context 'with minutes equal or grater to 10' do
      let(:weekday_time) { double(WeekdayTime, hour: 11, minutes: 34) }
      subject { described_class.new(weekday_time) }

      it 'returns a formatted time' do
        expect(subject.time).to eq('11:34')
      end
    end
  end
end
