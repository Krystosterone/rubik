require 'rails_helper'

describe EtsPdf::Parser::ParsedLine::Course do
  it_behaves_like 'ParsedLine'

  { 'ANG010' => 'ANG010       ANGLAIS POUR INGÉNIEURS I',
    'COM110' => 'COM110       MÉTHODES DE COMMUNICATION',
    'MATEST' => "MATEST       PROJET DE FIN D'ÉTUDES EN GÉNIE LOGICIEL                        PCL310",
    'PHYTEST' => 'PHYTEST      ÉLECTRICITÉ ET MAGNÉTISME                                       ING150'
  }.each do |course_code, line|
    context "when the line '#{line}' is passed" do
      subject { described_class.new(line) }

      it { is_expected.to be_parsed }
      its(:code) { is_expected.to eq(course_code) }
    end
  end
end
