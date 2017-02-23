# frozen_string_literal: true
require "rails_helper"

describe CourseColorsHelper do
  describe "#course_color_css_class" do
    let(:course_colors) { instance_double(CourseColorMap) }
    before { allow(course_colors).to receive(:[]).with("LOG430").and_return(42) }

    it "returns the right css class" do
      expect(helper.course_color_css_class(course_colors, "LOG430")).to eq("course-color-42")
    end
  end
end
