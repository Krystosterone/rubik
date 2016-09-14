# frozen_string_literal: true
require "rails_helper"

describe CourseScopes do
  it_behaves_like "CourseScopes", described_class: TestCourseScopedModel
end
