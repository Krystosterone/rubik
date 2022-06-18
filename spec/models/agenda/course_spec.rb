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
  let(:agenda) { build(:agenda, leaves: leaves) }
  let(:leaves) do
    [
      Leave.new(starts_at: 0, ends_at: 100),
      Leave.new(starts_at: 200, ends_at: 300),
    ]
  end

  it { is_expected.to belong_to(:academic_degree_term_course) }

  it do
    expect(course).to belong_to(:agenda).inverse_of(:courses).touch(true)
  end

  describe "presence validation of selected groups" do
    before do
      course.assign_attributes(academic_degree_term_course: academic_degree_term_course, group_numbers: [-1])
      course.validate
    end

    it { is_expected.not_to be_valid }
    it { expect(course.errors).to be_added(:selected_groups, :blank) }
  end

  it { is_expected.to delegate_method(:code).to(:academic_degree_term_course) }

  its(:group_numbers) { is_expected.to eq([]) }
  its(:mandatory) { is_expected.to be(false) }

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

  describe "#academic_degree_term_course_groups" do
    context "when there is no academic_degree_term_course" do
      before { course.academic_degree_term_course = nil }

      its(:academic_degree_term_course_groups) { is_expected.to eq([]) }
    end

    context "when there is an academic_degree_term_course" do
      its(:academic_degree_term_course_groups) { is_expected.to eq(academic_degree_term_course.groups) }
    end
  end

  describe "#group_numbers=" do
    before { course.group_numbers = ["", "", 1, 3, 5, "", nil] }

    specify { expect(course.group_numbers).to eq([1, 3, 5]) }
  end

  describe "#pruned_groups" do
    before { course.group_numbers = [1, 2] }

    it "returns groups that do not overlap with leaves" do
      expect(course.pruned_groups).to eq([Group.new(number: 1, periods: [Period.new(starts_at: 500, ends_at: 600)])])
    end
  end

  describe "#reset_group_numbers" do
    before { course.group_numbers = [] }

    it "sets the group numbers to the ones of the academic_degree_term_course" do
      expect { course.reset_group_numbers }
        .to change(course, :group_numbers).to(academic_degree_term_course.group_numbers)
    end
  end
end
