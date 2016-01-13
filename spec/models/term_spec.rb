require 'rails_helper'

describe Term do
  before { Timecop.freeze }
  after { Timecop.return }

  it { is_expected.to have_many(:academic_degree_terms) }
  it { is_expected.to have_many(:academic_degrees).through(:academic_degree_terms) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:year, :tags) }

  its(:enabled_at) { is_expected.to eq(Time.zone.now) }

  describe 'default scope' do
    let(:ordered_terms) { [] }
    before do
      ordered_terms[0] = create(:term, year: 2015, name: 'A', tags: 'B')
      ordered_terms[1] = create(:term, year: 2015, name: 'A', tags: 'C')
      ordered_terms[3] = create(:term, year: 2014, name: 'A', tags: 'B')
      ordered_terms[2] = create(:term, year: 2015, name: 'B', tags: 'B')
      create(:term, enabled_at: nil)
    end

    it 'returns terms in "year: :desc, name: :asc, tags: :asc" order for enabled terms' do
      expect(described_class.all).to eq(ordered_terms)
    end
  end
end
