# frozen_string_literal: true

require "rails_helper"

describe Agenda do
  subject(:agenda) { described_class.new }

  it { is_expected.to belong_to(:academic_degree_term) }
  it { is_expected.to have_one(:academic_degree).through(:academic_degree_term) }
  it { is_expected.to have_one(:term).through(:academic_degree_term) }
  it { is_expected.to have_many(:academic_degree_term_courses).through(:academic_degree_term) }
  it { is_expected.to have_many(:courses).dependent(:destroy).inverse_of(:agenda) }
  it { is_expected.to have_many(:schedules).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:courses).allow_destroy(true) }

  it { is_expected.to serialize(:leaves).as(LeavesSerializer) }
  it { is_expected.to accept_nested_attributes_for_serialized(:leaves, attributes: { starts_at: 0, ends_at: 100 }) }

  it { is_expected.to validate_presence_of(:courses) }
  it { is_expected.to validate_inclusion_of(:courses_per_schedule).in_range(1..5) }
  it { is_expected.to validate_with(Agenda::Validator) }

  its(:courses_per_schedule) { is_expected.to eq(1) }
  its(:processing) { is_expected.to eq(false) }
  its(:token) { is_expected.to be_present }

  it { is_expected.to delegate_method(:count).to(:schedules).with_prefix }
  it { is_expected.to delegate_method(:name).to(:academic_degree).with_prefix }

  describe "#to_param" do
    before { agenda.token = "a_token" }

    it "aliases to #token" do
      expect(agenda.to_param).to eq("a_token")
    end
  end

  describe "#mark_as_finished_processing" do
    before do
      Timecop.freeze(2016, 1, 1)
      agenda.mark_as_finished_processing
    end
    after { Timecop.return }

    its(:processing) { is_expected.to eq(false) }
    its(:combined_at) { is_expected.to eq(Time.zone.now) }
  end

  define :validate_with do |validator|
    match do |actual|
      expect_any_instance_of(validator).to receive(:validate).with(actual) # rubocop:disable RSpec/AnyInstance
      actual.valid?
      true
    end
  end
end
