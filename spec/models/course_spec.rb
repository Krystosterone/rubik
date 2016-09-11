# frozen_string_literal: true
require "rails_helper"

describe Course do
  it { is_expected.to have_many(:academic_degree_term_courses) }
  it { is_expected.to have_many(:academic_degree_terms).through(:academic_degree_term_courses) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
end
