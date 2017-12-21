# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::AcademicDegreeBuilder do
  describe ".call" do
    let(:term) { build(:term) }

    before { term.save! }

    context "with an invalid bachelor handle" do
      let(:units) { [{ bachelor_handle: "invalid" }] }

      it "raises an error" do
        expect { described_class.call(term, units) }.to raise_error("Invalid bachelor handle 'invalid'")
      end
    end

    described_class::BACHELOR_HANDLES.each do |denormalized_handle, normalized_handle|
      context "with a valid bachelor with handle '#{denormalized_handle}'" do
        let(:parsed_lines) { [instance_double(EtsPdf::Parser::ParsedLine)] }
        let(:units) { [{ bachelor_handle: denormalized_handle, parsed_lines: parsed_lines }] }

        before { allow(EtsPdf::Etl::AcademicDegreeTermCourseBuilder).to receive(:call) }

        {
          "do not exist" => proc{},
          "exist" => proc do
            academic_degree = create(:academic_degree, code: denormalized_handle, name: normalized_handle)
            create(:academic_degree_term, academic_degree: academic_degree)
          end,
        }.each do |condition, setup|
          context "when the academic degree and academic degree term #{condition}" do
            let(:academic_degree) { AcademicDegree.find_by!(code: denormalized_handle, name: normalized_handle) }
            let(:academic_degree_term) { term.academic_degree_terms.find_by!(academic_degree: academic_degree) }

            before(&setup)

            it "calls the academic degree term course builder" do
              described_class.call(term, units)

              expect(EtsPdf::Etl::AcademicDegreeTermCourseBuilder)
                .to have_received(:call).with(academic_degree_term, parsed_lines)
            end
          end
        end
      end
    end
  end
end
