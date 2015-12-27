require 'rails_helper'

describe ScheduleWeekdayDecorator do
  describe '#periods' do
    let(:schedule_weekday) { build(:schedule_weekday) }
    subject { described_class.new(schedule_weekday) }

    it 'returns decorated periods' do
      expect(subject.periods).to eq(schedule_weekday.periods)
      expect(subject.periods).to be_decorated
    end
  end

  describe '#collapsible?' do
    context 'when it is empty' do
      let(:schedule_weekday) { double(ScheduleWeekday, empty?: true) }
      subject { described_class.new(schedule_weekday) }

      specify { expect(subject).to be_collapsible }
    end

    context 'when there are some periods' do
      let(:schedule_weekday) { double(ScheduleWeekday, empty?: false) }
      subject { described_class.new(schedule_weekday) }

      specify { expect(subject).to_not be_collapsible }
    end
  end

  describe '#backdrop_class' do
    context 'when the weekday is not a weekend' do
      let(:schedule_weekday) { double(ScheduleWeekday, weekend?: false) }
      subject { described_class.new(schedule_weekday) }

      it 'returns nothing' do
        expect(subject.backdrop_class).to be_nil
      end
    end

    context 'when the weekday is a weekend weekday' do
      let(:schedule_weekday) { double(ScheduleWeekday, weekend?: true) }
      subject { described_class.new(schedule_weekday) }

      it 'returns the backdrop class' do
        expect(subject.backdrop_class).to eq('weekend')
      end
    end
  end

  describe '#css_class' do
    context 'for a weekend weekday with index 0' do
      let(:schedule_weekday) { double(ScheduleWeekday, index: 0, weekend?: true) }
      subject { described_class.new(schedule_weekday) }

      its(:css_class) { is_expected.to eq('weekday-0 weekend') }
    end

    (1..3).each do |index|
      context "for weekday of index #{index}" do
        let(:schedule_weekday) { double(ScheduleWeekday, index: index, weekend?: false) }
        subject { described_class.new(schedule_weekday) }

        its(:css_class) { is_expected.to eq("weekday-#{index}") }
      end
    end
  end

  describe '#name' do
    %w(Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi).each_with_index do |name, index|
      context "for index #{index}" do
        let(:schedule_weekday) { double(ScheduleWeekday, index: index) }
        subject { described_class.new(schedule_weekday) }

        it "returns the #{name}" do
          expect(subject.name).to eq(name)
        end
      end
    end
  end
end
