require 'rails_helper'

describe EtsPdf::Etl::Transform::BachelorUpdater do
  describe '#execute' do
    context 'for invalid bachelor handles' do
      let(:term) { double(Term) }
      let(:data) { { 'potato' => [] } }
      subject { described_class.new(term, data) }

      it 'raises an error' do
        expect { subject.execute }.to raise_error('Invalid bachelor handle "potato"')
      end
    end

    context 'for valid bachelor handles' do
      let(:term) { create(:term) }
      let(:data) do
        { 'seg' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'ctn' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'ele' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'log' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'mec' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'gol' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'gpa' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) },
          'gti' => 2.times.collect { double(EtsPdf::Parser::ParsedLine) } }
      end
      let(:academic_degree_updaters) do
        data.collect do |bachelor_handle, lines|
          bachelor_name = EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES.fetch(bachelor_handle)
          academic_degree = instance_with_attributes(code: bachelor_handle, name: bachelor_name)
          academic_degree_term = instance_with_attributes(academic_degree: academic_degree)
          academic_degree_updater = double(EtsPdf::Etl::Transform::AcademicDegreeUpdater)

          allow(EtsPdf::Etl::Transform::AcademicDegreeUpdater)
            .to receive(:new).with(academic_degree_term, lines).and_return(academic_degree_updater)
          academic_degree_updater
        end
      end
      subject { described_class.new(term, data) }
      before do
        academic_degree_updaters.each do |academic_degree_updater|
          expect(academic_degree_updater).to receive(:execute)
        end
      end

      context 'when no academic degrees exist' do
        it 'creates them' do
          subject.execute

          expect(term.academic_degree_terms.size).to eq(8)
          term.academic_degree_terms.each do |academic_degree_term|
            bachelor_name = EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES
                            .fetch(academic_degree_term.code)

            expect(EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES)
              .to include(academic_degree_term.code)
            expect(academic_degree_term.name).to eq(bachelor_name)
          end
        end
      end

      context 'when the academic degrees exist' do
        before do
          data.keys.each do |bachelor_handle|
            bachelor_name = EtsPdf::Etl::Transform::BachelorUpdater::BACHELOR_HANDLES
                            .fetch(bachelor_handle)

            academic_degree = AcademicDegree.create!(code: bachelor_handle, name: bachelor_name)
            term.academic_degree_terms.create!(academic_degree: academic_degree)
          end
        end

        it 'does not create new ones' do
          expect { subject.execute }.not_to change { term.academic_degree_terms.count }
        end
      end
    end
  end
end
