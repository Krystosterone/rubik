# frozen_string_literal: true
require "rails_helper"

describe Agenda::CoursesDecorator do
  subject(:decorator) { described_class.new(courses) }
  let(:courses) { build_list(:agenda_course, 2) }

  specify { expect(decorator).to be_decorated }
  specify { expect(decorator).to eq(courses) }
end
