require "rails_helper"

describe AcademicDegree do
  it { is_expected.to have_many(:academic_degree_terms) }
  it { is_expected.to have_many(:terms).through(:academic_degree_terms) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to validate_presence_of(:name) }
end
