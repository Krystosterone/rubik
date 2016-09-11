shared_examples "WeekdayTimeRangeDecorator" do |decorated_class:|
  describe "#time_span" do
    subject(:decorator) { described_class.new(weekday_time_range) }
    let(:weekday_time_range) do
      instance_double(decorated_class, starts_at: WeekTime.new(50), ends_at: WeekTime.new(4680))
    end

    it "returns a concatenated starts_at time and ends_at time" do
      expect(decorator.time_span).to eq("0:50 - 6:00")
    end
  end

  describe "#starts_at" do
    subject(:decorator) { described_class.new(weekday_time_range) }
    let(:weekday_time_range) { instance_double(decorated_class, starts_at: WeekTime.new(50)) }

    it "is a time" do
      expect(decorator.starts_at).to eq(weekday_time_range.starts_at)
    end

    it "is decorated" do
      expect(decorator.starts_at).to be_decorated
    end
  end

  describe "#ends_at" do
    subject(:decorator) { described_class.new(weekday_time_range) }
    let(:weekday_time_range) { instance_double(decorated_class, ends_at: WeekTime.new(50)) }

    it "is a time" do
      expect(decorator.ends_at).to eq(weekday_time_range.ends_at)
    end

    it "is decorated" do
      expect(decorator.ends_at).to be_decorated
    end
  end

  describe "#to_partial_path" do
    subject(:decorator) { described_class.new(decorated_class.new) }
    let(:partial_path) { decorated_class.name.underscore }

    it "returns the partial path" do
      expect(decorator.to_partial_path).to eq("schedules/#{partial_path}")
    end
  end
end
