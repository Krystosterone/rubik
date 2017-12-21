# frozen_string_literal: true

require "rails_helper"

describe Term do
  before { Timecop.freeze(2016, 1, 1) }
  after { Timecop.return }

  it { is_expected.to have_many(:academic_degree_terms).dependent(:destroy) }
  it { is_expected.to have_many(:academic_degrees).through(:academic_degree_terms) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:year, :tags) }

  describe ".enabled" do
    let(:ordered_terms) { [] }

    before do
      ordered_terms[0] = create(:term, year: 2015, name: "A", tags: "B")
      ordered_terms[1] = create(:term, year: 2015, name: "A", tags: "C")
      ordered_terms[3] = create(:term, year: 2014, name: "A", tags: "B")
      ordered_terms[2] = create(:term, year: 2015, name: "B", tags: "B")
      create(:term, enabled_at: nil)
    end

    it 'returns terms in "year: :desc, name: :asc, tags: :asc" order for enabled terms' do
      expect(described_class.enabled.all).to eq(ordered_terms)
    end
  end

  describe "#academic_degree_terms" do
    context "with default scope" do
      subject(:term) { create(:term) }

      let(:ordered) { [] }

      before do
        ordered[0] = create(:academic_degree_term, term: term, academic_degree: build(:academic_degree, name: "Z"))
        ordered[1] = create(:academic_degree_term, term: term, academic_degree: build(:academic_degree, name: "Y"))
        ordered[2] = create(:academic_degree_term, term: term, academic_degree: build(:academic_degree, name: "X"))
        ordered[3] = create(:academic_degree_term, term: term, academic_degree: build(:academic_degree, name: "W"))
      end

      it "orders them by name" do
        expect(term.reload.academic_degree_terms).to eq(ordered)
      end
    end
  end
end
