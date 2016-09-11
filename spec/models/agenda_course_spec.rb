# frozen_string_literal: true
require "rails_helper"

describe AgendaCourse do
  let(:groups) { [instance_double(Group)] }

  it { is_expected.to have_attr_accessor(:id) }
  it { is_expected.to have_attr_accessor(:code) }
  it { is_expected.to have_attr_accessor(:groups) }

  it { is_expected.to delegate_method(:empty?).to(:groups) }

  describe "#new" do
    context "with no attributes passed in" do
      its(:code) { is_expected.to be_nil }
      its(:groups) { is_expected.to be_empty }
    end

    context "with attributes passed in" do
      subject { described_class.new(id: 3, code: "ONE", groups: groups) }

      its(:id) { is_expected.to eq(3) }
      its(:code) { is_expected.to eq("ONE") }
      its(:groups) { is_expected.to eq(groups) }
    end
  end

  describe "#==" do
    it "returns false if courses do not match" do
      expect(described_class.new(code: "ONE", groups: []))
        .not_to eq(described_class.new(code: "ONE", groups: [double]))
    end

    it "returns true if courses match" do
      expect(described_class.new(code: "ONE", groups: groups))
        .to eq(described_class.new(code: "ONE", groups: groups))
    end
  end

  describe ".from" do
    subject { described_class.from(academic_degree_term_course) }
    let(:academic_degree_term_course) do
      instance_double(AcademicDegreeTermCourse, id: 3, code: "TWO", groups: [double])
    end

    its(:id) { is_expected.to eq(academic_degree_term_course.id) }
    its(:code) { is_expected.to eq(academic_degree_term_course.code) }
    its(:groups) { is_expected.to eq(academic_degree_term_course.groups) }
  end
end
