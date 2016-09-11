# frozen_string_literal: true
require "rails_helper"

describe AcademicDegreeTermCourse do
  it { is_expected.to belong_to(:academic_degree_term) }
  it { is_expected.to belong_to(:course) }

  it { is_expected.to validate_presence_of(:academic_degree_term) }
  it { is_expected.to validate_presence_of(:course) }

  it { is_expected.to validate_presence_of(:academic_degree_term) }
  it { is_expected.to validate_presence_of(:course) }

  it { is_expected.to serialize(:groups).as(GroupsSerializer) }
  it { is_expected.to find_or_initialize_for_serialized(:groups, attributes: { number: 1 }) }

  it { is_expected.to delegate_method(:code).to(:course) }

  describe "default scope" do
    let(:default_scope) { [] }
    before do
      default_scope[2] = create(:academic_degree_term_course, course: create(:course, code: "B121"))
      default_scope[0] = create(:academic_degree_term_course, course: create(:course, code: "A120"))
      default_scope[1] = create(:academic_degree_term_course, course: create(:course, code: "B120"))
    end

    it "orders them by course code" do
      expect(described_class.all).to eq(default_scope)
    end
  end
end
