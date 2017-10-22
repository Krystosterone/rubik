# frozen_string_literal: true
require "rails_helper"

describe AcademicDegreeTerm do
  it { is_expected.to belong_to(:academic_degree) }
  it { is_expected.to belong_to(:term) }
  it { is_expected.to have_many(:academic_degree_term_courses).dependent(:destroy) }
  it { is_expected.to have_many(:courses).through(:academic_degree_term_courses) }
  it { is_expected.to have_many(:agendas).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:academic_degree) }
  it { is_expected.to validate_presence_of(:term) }

  it { is_expected.to delegate_method(:name).to(:academic_degree) }
end
