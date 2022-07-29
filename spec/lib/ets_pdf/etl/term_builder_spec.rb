# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::TermBuilder do
  describe ".call" do
    let(:term_lines) do
      EtsPdf::TERM_NAMES.keys.map { |term_name| build(:parsed_term_line, name: term_name).term }
    end
    let(:term_attributes) do
      term_lines.map do |term_line|
        { name: term_line.name, year: term_line.year }
      end
    end
    let(:documents) do
      term_lines.map { |term_line| instance_double(EtsPdf::Parser::ParsedDocument, term_line: term_line) }
    end
    let(:filtered_documents) do
      documents.map { instance_double(EtsPdf::Parser::ParsedDocument) }
    end

    before do
      documents.each_with_index do |document, index|
        allow(document).to receive(:except).with(:term).and_return(filtered_documents[index])
      end
      allow(EtsPdf::Etl::AcademicDegreeBuilder).to receive(:call).exactly(documents.size).times
    end

    {
      "does not exist" => proc {},
      "already exists" => proc { Term.create!(term_attributes) },
    }.each do |condition, setup|
      context "when the term #{condition}" do
        before(&setup)

        it "calls the academic degree builder" do
          described_class.call(documents)

          documents.map(&:term_line).each_with_index do |term_line, index|
            expect(EtsPdf::Etl::AcademicDegreeBuilder).to have_received(:call)
              .with(Term.find_by!(name: term_line.name, year: term_line.year), filtered_documents[index])
          end
        end
      end
    end
  end
end
