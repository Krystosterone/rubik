# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Etl::Extract do
  TXT_SUBSET = "db/raw/ets/2015/hiver/**/*"

  describe ".call" do
    let(:expected_data) do
      {
        "2015" => {
          "hiver" => {
            "anciens" => {
              "ctn" => txt_matching(:anciens, :ctn),
              "ele" => txt_matching(:anciens, :ele),
              "gol" => txt_matching(:anciens, :gol),
              "gpa" => txt_matching(:anciens, :gpa),
              "gti" => txt_matching(:anciens, :gti),
              "log" => txt_matching(:anciens, :log),
              "mec" => txt_matching(:anciens, :mec),
              "seg" => txt_matching(:anciens, :seg),
            },
            "nouveaux" => {
              "ctn" => txt_matching(:nouveaux, :ctn),
              "ele" => txt_matching(:nouveaux, :ele),
              "gpa" => txt_matching(:nouveaux, :gpa),
              "gti" => txt_matching(:nouveaux, :gti),
              "log" => txt_matching(:nouveaux, :log),
              "mec" => txt_matching(:nouveaux, :mec),
            }
          }
        }
      }
    end
    before { allow(EtsPdf::Parser).to receive(:call) { |path| path } }

    it "returns a comprehensible data structure" do
      expect(described_class.call(TXT_SUBSET)).to match(expected_data)
    end
  end

  private

  def txt_matching(type, name)
    path = TXT_SUBSET.sub("**", type.to_s).sub("*", name.to_s)
    a_string_ending_with("#{path}.txt")
  end
end
