shared_examples 'WeekdayTimeRangeDecorator' do |decorated_class:|
  describe '#time_span' do
    let(:weekday_time_range) do
      double(decorated_class,
             starts_at: WeekTime.new(50),
             ends_at: WeekTime.new(4680))
    end
    subject { described_class.new(weekday_time_range) }

    it 'returns a concatenated starts_at time and ends_at time' do
      expect(subject.time_span).to eq('0:50 - 6:00')
    end
  end

  describe '#starts_at' do
    let(:weekday_time_range) { double(decorated_class, starts_at: WeekTime.new(50)) }
    subject { described_class.new(weekday_time_range) }

    it 'is decorated' do
      expect(subject.starts_at).to eq(weekday_time_range.starts_at)
      expect(subject.starts_at).to be_decorated
    end
  end

  describe '#ends_at' do
    let(:weekday_time_range) { double(decorated_class, ends_at: WeekTime.new(50)) }
    subject { described_class.new(weekday_time_range) }

    it 'is decorated' do
      expect(subject.ends_at).to eq(weekday_time_range.ends_at)
      expect(subject.ends_at).to be_decorated
    end
  end

  describe '#to_partial_path' do
    let(:partial_path) { decorated_class.name.underscore }
    subject { described_class.new(decorated_class.new) }

    it 'returns the partial path' do
      expect(subject.to_partial_path).to eq("schedules/#{partial_path}")
    end
  end
end
