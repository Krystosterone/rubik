# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Parser::ParsedLine::Period do
  it_behaves_like "ParsedLine"

  {
    "                   Lun       18:00 - 21:30   C           A-3336" => %w(Lun 18:00 21:30 C),
    "                   Jeu       13:30 - 17:00   TP          A-1350" => %w(Jeu 13:30 17:00 TP),
    "                   Mar       09:00 - 12:30   TP A+B      B-0908" => ["Mar", "09:00", "12:30", "TP A+B"],
    "                   Ven       08:45 - 12:15   TP-Labo A   B-3402" => ["Ven", "08:45", "12:15", "TP-Labo A"],
    "                   Mer       18:00 - 20:00   TP/Labo     A-3322" => %w(Mer 18:00 20:00 TP/Labo)
  }.each do |line, attributes|
    context "when the line '#{line}' is passed" do
      subject { described_class.new(line) }

      it { is_expected.to be_parsed }
      its(:weekday) { is_expected.to eq(attributes[0]) }
      its(:start_time) { is_expected.to eq(attributes[1]) }
      its(:end_time) { is_expected.to eq(attributes[2]) }
      its(:type) { is_expected.to eq(attributes[3]) }
    end
  end
end
