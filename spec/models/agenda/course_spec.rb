# frozen_string_literal: true
require "rails_helper"

describe Agenda::Course do
  subject(:course) { described_class.new(academic_degree_term_course: academic_degree_term_course, agenda: agenda) }
  let(:academic_degree_term_course) do
    AcademicDegreeTermCourse.new(groups: [
      Group.new(number: 1, periods: [Period.new(starts_at: 500, ends_at: 600)]),
      Group.new(number: 2, periods: [Period.new(starts_at: 50, ends_at: 70)]),
      Group.new(number: 3, periods: [Period.new(starts_at: 500, ends_at: 600)]),
    ])
  end
  let(:agenda) { build(:agenda, filter_groups: true, leaves: leaves) }
  let(:leaves) do
    [
      Leave.new(starts_at: 0, ends_at: 100),
      Leave.new(starts_at: 200, ends_at: 300),
    ]
  end

  it { is_expected.to belong_to(:academic_degree_term_course) }
  it { is_expected.to belong_to(:agenda).inverse_of(:courses).touch(true) }

  it { is_expected.to validate_presence_of(:academic_degree_term_course) }
  describe "presence validation of selected groups" do
    before do
      course.assign_attributes(academic_degree_term_course: academic_degree_term_course, group_numbers: [-1])
      course.validate
    end

    it { is_expected.not_to be_valid }
    it { expect(course.errors).to be_added(:selected_groups, :blank) }
  end

  it { is_expected.to delegate_method(:code).to(:academic_degree_term_course) }

  its(:mandatory) { is_expected.to eq(false) }

  describe "#groups" do
    context "when no academic_degree_term_course is provided" do
      before { course.academic_degree_term_course = nil }
      it { expect(course.groups).to eq([]) }
    end

    context "when an academic_degree_term_course is provided" do
      it { expect(course.groups).to eq(academic_degree_term_course.groups) }
    end
  end

  describe "#group_numbers" do
    context "when explicitly set" do
      before { course.group_numbers = [1, 2] }
      it { expect(course.group_numbers).to eq([1, 2]) }
    end

    context "when not set" do
      it { expect(course.group_numbers).to eq(academic_degree_term_course.groups.map(&:number)) }
    end
  end

  describe "scopes" do
    let!(:mandatory_courses) { create_list(:mandatory_agenda_course, 2) }
    let!(:optional_courses) { create_list(:agenda_course, 2) }

    describe ".mandatory" do
      specify { expect(described_class.mandatory).to eq(mandatory_courses) }
    end

    describe ".optional" do
      specify { expect(described_class.optional).to eq(optional_courses) }
    end
  end

  describe "#pruned_groups" do
    before { course.group_numbers = [1, 2] }

    context "when agenda does not filter groups" do
      before { agenda.filter_groups = false }

      it "returns groups that do not overlap with leaves" do
        expect(course.pruned_groups).to eq([
          Group.new(number: 1, periods: [Period.new(starts_at: 500, ends_at: 600)]),
          Group.new(number: 3, periods: [Period.new(starts_at: 500, ends_at: 600)]),
        ])
      end
    end

    context "when agenda does filter groupes" do
      it "returns groups that do not overlap with leaves and have been selected" do
        expect(course.pruned_groups).to eq([Group.new(number: 1, periods: [Period.new(starts_at: 500, ends_at: 600)])])
      end
    end
  end
end
