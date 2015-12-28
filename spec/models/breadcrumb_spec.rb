require 'rails_helper'

describe Breadcrumb do
  let(:academic_degree_term) { double(AcademicDegreeTerm) }
  let(:agenda) { double(Agenda, academic_degree_term: academic_degree_term) }
  let(:view_context) do
    double.tap do |view_context|
      allow(view_context).to receive(:t) { |key| key }
      allow(view_context).to receive(:root_path ).and_return('root_path')
      allow(view_context)
        .to receive(:new_academic_degree_term_agenda_path ).with(academic_degree_term).and_return('agenda_path')
      allow(view_context).to receive(:link_to) { |name, path| "#{name}_#{path}" }
      allow(view_context).to receive(:agenda).and_return(agenda)
    end
  end

  {
    'terms' => [],
    'agendas' => %w(.terms_root_path),
    'schedules' => %w(.terms_root_path .agendas_agenda_path),
  }.each do |handle, links|
    context "with current handle as #{handle}" do
      let(:current_handle) { handle }
      subject { described_class.new(view_context, current_handle) }

      describe '#current_name' do
        specify do
          expect(subject.render { current_name }).to eq(".#{handle}")
        end
      end

      describe '#links' do
        specify do
          expect do |b|
            subject.render { links(&b) }
          end.to yield_successive_args(*links)
        end
      end
    end
  end
end
