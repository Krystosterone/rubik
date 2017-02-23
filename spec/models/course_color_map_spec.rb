# frozen_string_literal: true
require "rails_helper"

describe CourseColorMap do
  describe "#[]" do
    context "with one course" do
      subject(:course_colors) { described_class.new(courses) }
      let(:courses) { [instance_double(Course, code: "LOG120")] }

      specify { expect(course_colors["LOG120"]).to eq(0) }
    end

    context "with 4 courses" do
      subject(:course_colors) { described_class.new(courses) }
      let(:courses) do
        [
          instance_double(Course, code: "LOG120"),
          instance_double(Course, code: "LOG121"),
          instance_double(Course, code: "LOG240"),
          instance_double(Course, code: "LOG420"),
        ]
      end

      specify { expect(course_colors["LOG120"]).to eq(0) }
      specify { expect(course_colors["LOG121"]).to eq(90) }
      specify { expect(course_colors["LOG240"]).to eq(180) }
      specify { expect(course_colors["LOG420"]).to eq(270) }
    end

    context "with quite a few courses" do
      subject(:course_colors) { described_class.new(courses) }
      let(:courses) do
        [
          instance_double(Course, code: "LOG120"),
          instance_double(Course, code: "LOG121"),
          instance_double(Course, code: "LOG240"),
          instance_double(Course, code: "LOG420"),
          instance_double(Course, code: "LOG610"),
          instance_double(Course, code: "LOG620"),
          instance_double(Course, code: "LOG630"),
          instance_double(Course, code: "LOG640"),
        ]
      end

      specify { expect(course_colors["LOG120"]).to eq(0) }
      specify { expect(course_colors["LOG121"]).to eq(45) }
      specify { expect(course_colors["LOG240"]).to eq(90) }
      specify { expect(course_colors["LOG420"]).to eq(135) }
      specify { expect(course_colors["LOG610"]).to eq(180) }
      specify { expect(course_colors["LOG620"]).to eq(225) }
      specify { expect(course_colors["LOG630"]).to eq(270) }
      specify { expect(course_colors["LOG640"]).to eq(315) }
    end
  end

  describe "#to_h" do
    subject(:course_colors) { described_class.new(courses) }
    let(:courses) do
      [
        instance_double(Course, code: "LOG120"),
        instance_double(Course, code: "LOG121"),
        instance_double(Course, code: "LOG240"),
        instance_double(Course, code: "LOG420"),
      ]
    end

    it "returns the hash representation" do
      expect(course_colors.to_h).to eq("LOG120" => 0, "LOG121" => 90, "LOG240" => 180, "LOG420" => 270)
    end
  end
end
