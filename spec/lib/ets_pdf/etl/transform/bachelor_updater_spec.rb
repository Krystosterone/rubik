require "rails_helper"

describe EtsPdf::Etl::Transform::BachelorUpdater do
  describe "#execute" do
    context "for invalid bachelor handles" do
      subject(:bachelor_updater) { described_class.new(term, data) }
      let(:term) { instance_double(Term) }
      let(:data) { { "potato" => [] } }

      it "raises an error" do
        expect { bachelor_updater.execute }.to raise_error('Invalid bachelor handle "potato"')
      end
    end

    context "for valid bachelor handles" do
      subject(:bachelor_updater) { described_class.new(term, data) }
      let(:term) { create(:term) }
      let(:data) do
        {
          "seg" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "ctn" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "ele" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "log" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "mec" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "gol" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "gpa" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
          "gti" => Array.new(2) { instance_double(EtsPdf::Parser::ParsedLine) },
        }
      end
      let(:academic_degree_updaters) do
        data.collect do |bachelor_handle, lines|
          bachelor_name = EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES.fetch(bachelor_handle)
          academic_degree = instance_with_attributes(code: bachelor_handle, name: bachelor_name)
          academic_degree_term = instance_with_attributes(academic_degree: academic_degree)
          academic_degree_updater = instance_double(EtsPdf::Etl::Transform::AcademicDegreeUpdater)

          allow(EtsPdf::Etl::Transform::AcademicDegreeUpdater)
            .to receive(:new).with(academic_degree_term, lines).and_return(academic_degree_updater)
          academic_degree_updater
        end
      end
      before do
        academic_degree_updaters.each do |academic_degree_updater|
          allow(academic_degree_updater).to receive(:execute)
        end
      end

      context "when no academic degrees exist" do
        before { bachelor_updater.execute }
        let(:academic_degree_terms) { term.academic_degree_terms }
        let(:actual_academic_degree_terms_attributes) { academic_degree_terms.pluck(:code, :name).sort }
        let(:expected_academic_degree_terms_attributes) do
          EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES.to_a.sort
        end

        it "creates all of them" do
          expect(term.academic_degree_terms.size).to eq(8)
        end

        it "creates them appropriatly" do
          expect(actual_academic_degree_terms_attributes).to eq(expected_academic_degree_terms_attributes)
        end
      end

      context "when the academic degrees exist" do
        before do
          data.keys.each do |bachelor_handle|
            bachelor_name = EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES
                            .fetch(bachelor_handle)

            academic_degree = AcademicDegree.create!(code: bachelor_handle, name: bachelor_name)
            term.academic_degree_terms.create!(academic_degree: academic_degree)
          end
        end

        it "does not create new ones" do
          expect { bachelor_updater.execute }.not_to change { term.academic_degree_terms.count }
        end
      end
    end
  end
end
