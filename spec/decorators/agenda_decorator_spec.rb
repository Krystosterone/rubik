require "rails_helper"

describe AgendaDecorator do
  subject(:decorator) { described_class.new(agenda) }
  let(:term) { build_stubbed(:term, year: 2016, name: "ABC", tags: "some tags") }
  let(:academic_degree) { instance_double(AcademicDegree, name: "XYZ") }
  let(:agenda) { instance_double(Agenda, academic_degree: academic_degree, term: term) }

  its(:academic_degree_name) { is_expected.to eq("XYZ") }
  its(:term_title) { is_expected.to eq("ABC 2016 - some tags") }

  describe "#term" do
    specify { expect(decorator.term).to be_decorated }
    specify { expect(decorator.term).to eq(agenda.term) }
  end
end
