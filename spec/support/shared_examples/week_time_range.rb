shared_examples 'WeekTimeRange' do
  it_behaves_like 'WeekdayTimeRange'
  it_behaves_like 'it has a coerced attr_accessor', :starts_at, WeekTime
  it_behaves_like 'it has a coerced attr_accessor', :ends_at, WeekTime

  describe '#to_weekday_time_ranges' do
    context 'when it starts at 0 and ends at 1440' do
      subject { described_class.new(starts_at: 0, ends_at: 1440) }

      it 'returns the weekday time range within associated weekday index' do
        expect(subject.to_weekday_time_ranges).to eq(
          0 => WeekdayTimeRange.new(starts_at: 0, ends_at: 1440),
        )
      end
    end

    context 'when it starts at 0 and ends at 2880' do
      subject { described_class.new(starts_at: 0, ends_at: 2880) }

      it 'returns the weekday time range within associated weekday index' do
        expect(subject.to_weekday_time_ranges).to eq(
          0 => WeekdayTimeRange.new(starts_at: 0, ends_at: 1440),
          1 => WeekdayTimeRange.new(starts_at: 0, ends_at: 1440),
        )
      end
    end

    context 'when it starts at 250 and ends at 4500' do
      subject { described_class.new(starts_at: 1600, ends_at: 4500) }

      it 'returns the weekday time range within associated weekday index' do
        expect(subject.to_weekday_time_ranges).to eq(
          1 => WeekdayTimeRange.new(starts_at: 160, ends_at: 1440),
          2 => WeekdayTimeRange.new(starts_at: 0, ends_at: 1440),
          3 => WeekdayTimeRange.new(starts_at: 0, ends_at: 180),
        )
      end
    end
  end
end
