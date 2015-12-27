require 'rails_helper'

describe EtsPdf::Parser::ParsedLine::Group do
  it_behaves_like 'ParsedLine'

  {
    '             02    Lun       18:00 - 21:30   C           A-3336               M. Brouillette' => %w(02 Lun 18:00 21:30 C),
    '             01    Jeu       13:30 - 17:00   TP          A-1350               L.Trudeau' => %w(01 Jeu 13:30 17:00 TP),
    '             15    Mar       09:00 - 12:30   TP A+B      B-0908               P. Choquette' => ['15', 'Mar', '09:00', '12:30', 'TP A+B'],
    '             01    Ven       08:45 - 12:15   TP-Labo A   B-3402               C. Talhi' => ['01', 'Ven', '08:45', '12:15', 'TP-Labo A'],
    '             01    Mer       18:00 - 20:00   TP/Labo     A-3322               F. Robert' => %w(01 Mer 18:00 20:00 TP/Labo)
  }.each do |line, attributes|
    context "when the line '#{line}' is passed" do
      subject { described_class.new(line) }

      it { is_expected.to be_parsed }
      its(:number) { is_expected.to eq(attributes[0]) }
      its(:weekday) { is_expected.to eq(attributes[1]) }
      its(:start_time) { is_expected.to eq(attributes[2]) }
      its(:end_time) { is_expected.to eq(attributes[3]) }
      its(:type) { is_expected.to eq(attributes[4]) }
    end
  end
end
