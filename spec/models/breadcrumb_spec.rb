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
        .with(agenda, step: AgendaCreationProcess::STEP_FILTER_SELECTION).and_return("agenda_filter_selection_path")
      allow(view_context)
        .to receive(:edit_agenda_path)
        .with(agenda, step: AgendaCreationProcess::STEP_COURSE_SELECTION).and_return("agenda_course_selection_path")
      allow(view_context)
        .to receive(:edit_agenda_path)
        .with(agenda, step: AgendaCreationProcess::STEP_GROUP_SELECTION).and_return("agenda_group_selection_path")
      allow(view_context).to receive(:link_to) { |name, path| "#{name}_#{path}" }

      view_context.instance_variable_set(:@agenda, agenda)
    end
  end

  {
    "terms" => %w(.terms_root_path),
    "schedules" => %w(
      .terms_root_path
      .agendas.filter_selection_agenda_filter_selection_path
      .agendas.course_selection_agenda_course_selection_path
    ),
  }.each do |controller_name, links|
    context "with controller '#{controller_name}'" do
      before do
        allow(view_context).to receive(:controller_name).and_return(controller_name)
      end

      describe "#current_name" do
        it "outputs the current name" do
          expect(breadcrumb.render { current_name }).to eq(".#{controller_name}")
        end
      end

      describe "#links" do
        specify do
          expect { |block| breadcrumb.render { links(&block) } }.to yield_successive_args(*links)
        end
      end
    end
  end

  [
    AgendaCreationProcess::STEP_FILTER_SELECTION,
    AgendaCreationProcess::STEP_COURSE_SELECTION,
    AgendaCreationProcess::STEP_GROUP_SELECTION,
  ].each do |step|
    context "with controller 'agendas' with step '#{step}' and no group filtering" do
      before do
        allow(view_context).to receive(:controller_name).and_return("agendas")
        allow(view_context).to receive(:step).and_return(AgendaCreationProcess::STEP_COURSE_SELECTION)
      end

      describe "#current_name" do
        it "outputs the current name" do
          expect(breadcrumb.render { current_name }).to eq(".agendas.#{AgendaCreationProcess::STEP_COURSE_SELECTION}")
        end
      end

      describe "#links" do
        specify do
          expect { |block| breadcrumb.render { links(&block) } }
            .to yield_successive_args(".terms_root_path", ".agendas.filter_selection_agenda_filter_selection_path")
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

    describe "#current_name" do
      it "outputs the current name" do
        expect(breadcrumb.render { current_name }).to eq(".agendas.#{AgendaCreationProcess::STEP_GROUP_SELECTION}")
      end
    end

    describe "#links" do
      specify do
        expect { |block| breadcrumb.render { links(&block) } }
          .to yield_successive_args(
            ".terms_root_path",
            ".agendas.filter_selection_agenda_filter_selection_path",
            ".agendas.course_selection_agenda_course_selection_path",
          )
      end
    end
  end

  context "with controller 'schedules' and group filtering" do
    before do
      allow(agenda).to receive(:filter_groups?).and_return(true)
      allow(view_context).to receive(:controller_name).and_return("schedules")
    end

    describe "#current_name" do
      it "outputs the current name" do
        expect(breadcrumb.render { current_name }).to eq(".schedules")
      end
    end

    describe "#links" do
      specify do
        expect { |block| breadcrumb.render { links(&block) } }
          .to yield_successive_args(
            ".terms_root_path",
            ".agendas.filter_selection_agenda_filter_selection_path",
            ".agendas.course_selection_agenda_course_selection_path",
            ".agendas.group_selection_agenda_group_selection_path",
          )
      end
    end
  end
end
