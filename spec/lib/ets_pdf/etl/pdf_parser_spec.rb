# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::PdfParser do
  let(:txt_subset) { Dir.glob(Rails.root.join("db", "raw", "ets", "2019", "hiver", "**", "*.txt")) }

  describe ".call" do
    let(:expected_data) do
      [
        line(2019, "hiver", "ctn"),
        line(2019, "hiver", "ele"),
        line(2019, "hiver", "gol"),
        line(2019, "hiver", "gpa"),
        line(2019, "hiver", "gti"),
        line(2019, "hiver", "log"),
        line(2019, "hiver", "mec"),
        line(2019, "hiver", "seg"),
      ]
    end

    before { allow(EtsPdf::Parser).to receive(:call) { |path| path } }

    it "returns a comprehensible data structure" do
      expect(described_class.call(txt_subset)).to contain_exactly(*expected_data)
    end
  end

  private

  def line(year, term_handle, bachelor_handle)
    {
      bachelor_handle: bachelor_handle,
      parsed_lines: Rails.root.join("db", "raw", "ets", year.to_s, term_handle, "#{bachelor_handle}.txt").to_s,
      term_handle: term_handle,
      year: year.to_s,
    }
  end
end
