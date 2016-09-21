# frozen_string_literal: true
require "rails_helper"

describe Agenda::Course do
  subject(:course) { described_class.new }
  it { is_expected.to belong_to(:academic_degree_term_course) }
  it { is_expected.to belong_to(:agenda).inverse_of(:courses) }

  it { is_expected.to validate_presence_of(:academic_degree_term_course) }

  it { is_expected.to delegate_method(:code).to(:academic_degree_term_course) }
  it { is_expected.to delegate_method(:groups).to(:academic_degree_term_course) }

  its(:mandatory) { is_expected.to eq(false) }

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
    subject(:course) { described_class.new(academic_degree_term_course: academic_degree_term_course, agenda: agenda) }
    let(:agenda) { build(:agenda, leaves: leaves) }
    let(:leaves) do
      [
        Leave.new(starts_at: 0, ends_at: 100),
        Leave.new(starts_at: 200, ends_at: 300),
      ]
    end
    let(:academic_degree_term_course) do
      AcademicDegreeTermCourse.new(groups: [
        Group.new(periods: [Period.new(starts_at: 500, ends_at: 600)]),
        Group.new(periods: [Period.new(starts_at: 50, ends_at: 70)]),
      ])
    end

    it "returns groups that do not overlap with leaves" do
      expect(course.pruned_groups).to eq([Group.new(periods: [Period.new(starts_at: 500, ends_at: 600)])])
    end
  end
end
