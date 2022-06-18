# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::PdfParser do
  let(:txt_subset) { "db/raw/ets/2015/hiver/**/*" }

  describe ".call" do
    let(:expected_data) do
      [
        line(2015, "hiver", "anciens", "ctn"),
        line(2015, "hiver", "anciens", "ele"),
        line(2015, "hiver", "anciens", "gol"),
        line(2015, "hiver", "anciens", "gpa"),
        line(2015, "hiver", "anciens", "gti"),
        line(2015, "hiver", "anciens", "log"),
        line(2015, "hiver", "anciens", "mec"),
        line(2015, "hiver", "anciens", "seg"),

        line(2015, "hiver", "nouveaux", "ctn"),
        line(2015, "hiver", "nouveaux", "ele"),
        line(2015, "hiver", "nouveaux", "gpa"),
        line(2015, "hiver", "nouveaux", "gti"),
        line(2015, "hiver", "nouveaux", "log"),
        line(2015, "hiver", "nouveaux", "mec"),
      ]
    end

    before { allow(EtsPdf::Parser).to receive(:call) { |path| path } }

    it "returns a comprehensible data structure" do
      expect(described_class.call(txt_subset)).to contain_exactly(*expected_data)
    end
  end

  private

  def line(year, term_handle, type, bachelor_handle)
    {
      bachelor_handle: bachelor_handle,
      parsed_lines: txt_matching(type, bachelor_handle),
      term_handle: term_handle,
      type: type,
      year: year.to_s,
    }
  end

  def txt_matching(type, bachelor_handle)
    path = txt_subset.sub("**", type).sub("*", bachelor_handle)
    a_string_ending_with("#{path}.txt")
  end
end
