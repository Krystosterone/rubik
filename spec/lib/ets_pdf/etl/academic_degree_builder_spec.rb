# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::AcademicDegreeBuilder do
  describe ".call" do
    shared_examples "it calls the academic degree term course builder" do
      let(:filered_document) { instance_double(EtsPdf::Parser::ParsedDocument, parsed_lines: parsed_lines) }
      let(:parsed_lines) { build_list(:parsed_course_line, 3) }
      let(:academic_degree_term) { term.academic_degree_terms.find_by!(academic_degree: academic_degree) }

      before do
        allow(document).to receive(:except).with(:bachelor).and_return(filered_document)
        allow(EtsPdf::Etl::AcademicDegreeTermCourseBuilder).to receive(:call)
      end

      it "calls the academic degree term course builder" do
        described_class.call(term, document)

        expect(EtsPdf::Etl::AcademicDegreeTermCourseBuilder)
          .to have_received(:call).with(academic_degree_term, parsed_lines)
      end
    end

    let(:term) { build(:term) }

    before { term.save! }

    EtsPdf::BACHELOR_HANDLES.each do |name, code|
      context "for a bachelor with name: #{name} (#{code})" do
        let(:bachelor_line) { build(:parsed_bachelor_line, name: name).bachelor }
        let(:document) { instance_double(EtsPdf::Parser::ParsedDocument, bachelor_line: bachelor_line) }

        context "when the academic degree does not exist" do
          let(:academic_degree) { AcademicDegree.find_by!(code: code, name: name) }

          it_behaves_like "it calls the academic degree term course builder"
        end

        context "when the academic degree exists" do
          let(:academic_degree) { build(:academic_degree, code: code, name: name) }

          before { academic_degree.save! }

          context "when the academic degree term exists" do
            before { create(:academic_degree_term, term: term, academic_degree: academic_degree) }

            it "raises an error" do
              expect { described_class.call(term, document) }
                .to raise_error(/Unable to create "AcademicDegreeTerm"/)
            end
          end

          context "when the academic degree does not exist" do
            it_behaves_like "it calls the academic degree term course builder"
          end
        end
      end
    end
  end
end
