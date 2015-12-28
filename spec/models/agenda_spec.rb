require 'rails_helper'

describe Agenda do
  it { is_expected.to belong_to(:academic_degree_term) }
  it { is_expected.to have_one(:academic_degree).through(:academic_degree_term) }
  it { is_expected.to have_one(:term).through(:academic_degree_term) }
  it { is_expected.to have_many(:academic_degree_term_courses).through(:academic_degree_term) }
  it { is_expected.to have_many(:schedules).dependent(:destroy) }

  it { is_expected.to serialize(:courses).as(AgendaCoursesSerializer) }
  it { is_expected.to serialize(:leaves).as(LeavesSerializer) }

  it { is_expected.to accept_nested_attributes_for_serialized(:leaves, attributes: { starts_at: 0, ends_at: 100 }) }

  it { is_expected.to validate_presence_of(:courses) }
  it { is_expected.to validate_inclusion_of(:courses_per_schedule).in_range(1..5) }

  it { is_expected.to validate_with(AgendaCoursesValidator) }

  describe '#new' do
    its(:course_ids) { is_expected.to eq([]) }
    its(:courses_per_schedule) { is_expected.to eq(1) }
    its(:token) { is_expected.to_not be_nil }
  end

  describe '#to_param' do
    before { subject.token = 'a_token' }

    it 'aliases to #token' do
      expect(subject.to_param).to eq('a_token')
    end
  end

  it { is_expected.to delegate_method(:empty?).to(:schedules) }

  describe '#course_ids=' do
    let(:academic_degree_term) { create(:academic_degree_term) }
    let(:academic_degree_term_courses) do
      create_list(:academic_degree_term_course, 4, academic_degree_term: academic_degree_term)
    end
    let(:course_ids) { academic_degree_term_courses.collect(&:id) }
    let(:courses) { academic_degree_term_courses.collect { |course| AgendaCourse.from(course) } }

    context 'from a new instance' do
      before do
        subject.academic_degree_term = academic_degree_term
        subject.save!(validate: false)
      end

      it 'assigns the right courses' do
        expect { subject.course_ids = course_ids }.to change { subject.courses }.from([]).to(courses)
      end
    end

    context 'from an instance derived of an academic_degree_term' do
      subject { academic_degree_term.agendas.new(course_ids: course_ids) }

      it 'assigns the right courses' do
        expect(subject.courses).to eq(courses)
      end
    end
  end

  describe '#course_ids' do
    let(:courses) { [AgendaCourse.new(id: 3), AgendaCourse.new(id: 9000)] }
    before { subject.courses = courses }

    its(:course_ids) { is_expected.to eq([3, 9000]) }
  end

  describe '#combine' do
    context 'when leaves have been altered' do
      before do
        subject.leaves_attributes = { '0' => { '_create' => '1',
                                               '_destroy' => '1' } }
      end

      it 'does not do anything' do
        expect(subject.combine).to eq(false)
      end
    end

    context 'when no leaves have been altered' do
      subject { create(:combined_agenda) }

      it 'deletes all associated schedules' do
        expect { subject.combine }.to change { subject.schedules.count }.to(0)
      end

      it 'resets the combined timestamp' do
        expect { subject.combine }.to change { subject.combined_at }.to(nil)
      end

      context 'when it was not able to save' do
        before { subject.courses_per_schedule = 0 }

        specify { expect(subject.combine).to eq(false) }
      end

      context 'when it saved' do
        specify { expect(subject.combine).to eq(true) }
      end
    end
  end

  describe '#processing?' do
    context 'when there is no combined timestamp' do
      it 'returns true' do
        expect(subject).to be_processing
      end
    end

    context 'when there is a combined timestamp' do
      before { subject.combined_at = Time.zone.now }

      it 'returns false' do
        expect(subject).to_not be_processing
      end
    end
  end

  describe 'validating leaves' do
    context 'when any leave is invalid' do
      before { subject.leaves << Leave.new(starts_at: 2000, ends_at: 1000) }

      it 'adds an error on leaves' do
        expect(subject).not_to be_valid
        expect(subject.errors).to be_added(:leaves, :invalid)
      end
    end

    context 'when all leaves are valid' do
      before { subject.valid? }

      it 'adds no errors on leaves' do
        expect(subject.errors).not_to be_added(:leaves, :invalid)
      end
    end
  end

  define :validate_with do |validator|
    match do |actual|
      expect_any_instance_of(validator).to receive(:validate).with(actual)
      actual.valid?
      true
    end
  end
end
