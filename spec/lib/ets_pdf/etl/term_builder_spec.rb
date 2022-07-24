# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::TermBuilder do
  describe ".call" do
    context "with an invalid term handle" do
      let(:units) { [{ term_handle: "invalid" }] }

      it "raises an error" do
        expect { described_class.call(units) }.to raise_error("Invalid term handle 'invalid'")
      end
    end

    described_class::TERM_HANDLES.each do |denormalized_term, normalized_term|
      context "with a valid line with handle '#{denormalized_term}'" do
        let(:term) { Term.find_by!(name: normalized_term, year: 2015) }
        let(:units) do
          [{ another_attribute: "value", term_handle: denormalized_term, year: "2015" }]
        end

        before { allow(EtsPdf::Etl::AcademicDegreeBuilder).to receive(:call) }

        {
          "does not exist" => proc {},
          "already exists" => proc { create(:term, name: normalized_term, year: 2015) },
        }.each do |condition, setup|
          context "when the term #{condition}" do
            before(&setup)

            it "calls the academic degree builder" do
              described_class.call(units)

              expect(EtsPdf::Etl::AcademicDegreeBuilder)
                .to have_received(:call).with(term, [{ another_attribute: "value" }])
            end
          end
        end
      end
    end
  end
end
