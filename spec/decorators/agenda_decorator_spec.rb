require "rails_helper"

describe AgendaDecorator do
  let(:term) { build_stubbed(:term, year: 2016, name: "ABC", tags: "some tags") }
  let(:academic_degree) { double(AcademicDegree, name: "XYZ") }
  let(:agenda) { double(Agenda, academic_degree: academic_degree, term: term) }
  subject { described_class.new(agenda) }

  its(:academic_degree_name) { is_expected.to eq("XYZ") }
  its(:term_title) { is_expected.to eq("ABC 2016 - some tags") }

  describe '#term' do
    it "decorates term" do
      expect(subject.term).to eq(agenda.term)
      expect(subject.term).to be_decorated
    end
  end
end
