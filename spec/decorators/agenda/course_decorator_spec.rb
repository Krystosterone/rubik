# frozen_string_literal: true
require "rails_helper"

describe Agenda::CourseDecorator do
  subject(:decorator) { described_class.new(course) }
  let(:course) { build(:agenda_course) }

  describe "#groups" do
    specify { expect(decorator.groups).to be_decorated }
    specify { expect(decorator.groups).to eq(course.groups) }
  end
end
