require 'rails_helper'

describe WeekTimeDecorator do
  describe '#weekday_time' do
    let(:week_time) { double(WeekTime, weekday_index: 5, hour: 4, minutes: 0) }
    subject { described_class.new(week_time) }

    it 'returns a concatenation of the weekday name and the time' do
      expect(subject.weekday_time).to eq('Vendredi 4:00')
    end
  end
end
