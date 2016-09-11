require "rails_helper"

describe Breadcrumb do
  let(:academic_degree_term) { instance_double(AcademicDegreeTerm) }
  let(:agenda) { instance_double(Agenda, academic_degree_term: academic_degree_term) }
  let(:view_context) do
    double.tap do |view_context|
      allow(view_context).to receive(:t) { |key| key }
      allow(view_context).to receive(:root_path).and_return("root_path")
      allow(view_context)
        .to receive(:new_academic_degree_term_agenda_path).with(academic_degree_term).and_return("agenda_path")
      allow(view_context).to receive(:link_to) { |name, path| "#{name}_#{path}" }
      allow(view_context).to receive(:agenda).and_return(agenda)
    end
  end

  {
    "terms" => [],
    "agendas" => %w(.terms_root_path),
    "schedules" => %w(.terms_root_path .agendas_agenda_path),
  }.each do |handle, links|
    context "with current handle as #{handle}" do
      subject(:breadcrumb) { described_class.new(view_context, current_handle) }
      let(:current_handle) { handle }

      describe "#current_name" do
        specify do
          expect(breadcrumb.render { current_name }).to eq(".#{handle}")
        end
      end

      describe "#links" do
        specify do
          expect do |b|
            breadcrumb.render { links(&b) }
          end.to yield_successive_args(*links)
        end
      end
    end
  end
end
