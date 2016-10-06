# frozen_string_literal: true
require "rails_helper"

describe Breadcrumb do
  subject(:breadcrumb) { described_class.new(view_context) }
  let(:academic_degree_term) { instance_double(AcademicDegreeTerm) }
  let(:agenda) { instance_double(Agenda, academic_degree_term: academic_degree_term, filter_groups?: false) }
  let(:view_context) do
    double.tap do |view_context|
      allow(view_context).to receive(:t) { |key| key }
      allow(view_context).to receive(:root_path).and_return("root_path")
      allow(view_context)
        .to receive(:edit_agenda_path)
        .with(agenda, step: AgendaCreationProcess::STEP_COURSE_SELECTION).and_return("agenda_course_selection_path")
      allow(view_context)
        .to receive(:edit_agenda_path)
        .with(agenda, step: AgendaCreationProcess::STEP_GROUP_SELECTION).and_return("agenda_group_selection_path")
      allow(view_context).to receive(:link_to) { |name, path| "#{name}_#{path}" }
      allow(view_context).to receive(:agenda).and_return(agenda)
    end
  end

  {
    "terms" => %w(.terms_root_path),
    "schedules" => %w(.terms_root_path .agendas.course_selection_agenda_course_selection_path),
  }.each do |controller_name, links|
    context "with controller '#{controller_name}'" do
      before do
        allow(view_context).to receive(:controller_name).and_return(controller_name)
      end

      its(:current_name) { is_expected.to eq(".#{controller_name}") }

      describe "#links" do
        specify do
          expect { |block| breadcrumb.links(&block) }.to yield_successive_args(*links)
        end
      end
    end
  end

  [
    AgendaCreationProcess::STEP_COURSE_SELECTION,
    AgendaCreationProcess::STEP_GROUP_SELECTION,
  ].each do |step|
    context "with controller 'agendas' with step '#{step}' and no group filtering" do
      before do
        allow(view_context).to receive(:controller_name).and_return("agendas")
        allow(view_context).to receive(:step).and_return(AgendaCreationProcess::STEP_COURSE_SELECTION)
      end

      its(:current_name) { is_expected.to eq(".agendas.#{AgendaCreationProcess::STEP_COURSE_SELECTION}") }

      describe "#links" do
        specify do
          expect { |block| breadcrumb.links(&block) }.to yield_successive_args(".terms_root_path")
        end
      end
    end
  end

  context "with controller 'agendas' with step '#{AgendaCreationProcess::STEP_GROUP_SELECTION}' and group filtering" do
    before do
      allow(agenda).to receive(:filter_groups?).and_return(true)
      allow(view_context).to receive(:controller_name).and_return("agendas")
      allow(view_context).to receive(:step).and_return(AgendaCreationProcess::STEP_GROUP_SELECTION)
    end

    its(:current_name) { is_expected.to eq(".agendas.#{AgendaCreationProcess::STEP_GROUP_SELECTION}") }

    describe "#links" do
      specify do
        expect { |block| breadcrumb.links(&block) }
          .to yield_successive_args(".terms_root_path", ".agendas.course_selection_agenda_course_selection_path")
      end
    end
  end
end
