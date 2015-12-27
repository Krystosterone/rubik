require 'rails_helper'

describe ScheduleLeaveDecorator do
  it_behaves_like 'WeekdayTimeRangeDecorator', decorated_class: ScheduleLeave

  describe '#css_class' do
    let(:weekday_time_range) do
      double(ScheduleLeave, starts_at: WeekTime.new(1000), duration: 4000)
    end
    subject { described_class.new(weekday_time_range) }

    it 'returns the class with restricted starts_at' do
      expect(subject.css_class).to eq('leave from-1000 duration-4000')
    end
  end
end
