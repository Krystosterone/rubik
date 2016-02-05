shared_examples "ParsedLine" do
  [
    "ÉCOLE DE TECHNOLOGIE SUPÉRIEURE",
    "                                             HORAIRE AUTOMNE 2013",
    "COURS        GR    JOUR        HEURE         ACTIVITÉ    LOCAL                ENSEIGNANT             PRÉALABLES",
    "         Date : 2013-09-19    "
  ].each do |invalid_line|
    context "when the line '#{invalid_line}' is passed" do
      subject { described_class.new(invalid_line) }
      it { is_expected.not_to be_parsed }
    end
  end
end
