# frozen_string_literal: true
require "rails_helper"

describe AgendaCreationProcess do
  subject(:process) { described_class.new(agenda) }
  let(:agenda) { build(:combined_agenda) }

  describe "#path" do
    context "with a single step" do
      before { agenda.filter_groups = false }
      specify { expect(process.path).to eq("/agendas/#{agenda.token}/schedules/processing") }
    end

    context "with multiple steps" do
      before { agenda.filter_groups = true }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }
        specify { expect(process.path).to eq("/agendas/#{agenda.token}/edit?step=group_selection") }
      end

      context "on the last step" do
        before { process.step = AgendaCreationProcess::STEP_GROUP_SELECTION }
        specify { expect(process.path).to eq("/agendas/#{agenda.token}/schedules/processing") }
      end
    end
  end

  describe "#save" do
    context "with a single step" do
      before { agenda.filter_groups = false }

      context "with a failed save" do
        let(:save_result) { process.save }
        before { agenda.courses_per_schedule = 99 }

        specify { expect(save_result).to eq(false) }
        specify { expect(agenda.processing).to eq(false) }
        specify { expect(agenda.combined_at).to be_present }
      end

      context "with a successful save" do
        let!(:save_result) { process.save }

        specify { expect(save_result).to eq(true) }
        specify { expect(agenda.processing).to eq(true) }
        specify { expect(agenda.combined_at).to be_nil }
        specify { expect(ScheduleGeneratorJob).to have_been_enqueued.with(global_id(agenda)) }
      end
    end

    context "with multiple steps" do
      before { agenda.filter_groups = true }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }

        context "with a failed save" do
          let(:save_result) { process.save }
          before { agenda.courses_per_schedule = 99 }

          specify { expect(save_result).to eq(false) }
          specify { expect(agenda.processing).to eq(false) }
          specify { expect(agenda.combined_at).to be_present }
        end

        context "with a successful save" do
          specify { expect(process.save).to eq(true) }
        end
      end

      context "on the last step" do
        before { process.step = AgendaCreationProcess::STEP_GROUP_SELECTION }

        context "with a failed save" do
          let(:save_result) { process.save }
          before { agenda.courses_per_schedule = 99 }

          specify { expect(save_result).to eq(false) }
          specify { expect(agenda.processing).to eq(false) }
          specify { expect(agenda.combined_at).to be_present }
        end

        context "with a successful save" do
          let!(:save_result) { process.save }

          specify { expect(save_result).to eq(true) }
          specify { expect(agenda.processing).to eq(true) }
          specify { expect(agenda.combined_at).to be_nil }
          specify { expect(ScheduleGeneratorJob).to have_been_enqueued.with(global_id(agenda)) }
        end
      end
    end
  end

  describe "#step" do
    context "with a single step" do
      [:one, :two].each do |step|
        before do
          agenda.filter_groups = false
          process.step = step
        end
        specify { expect(process.step).to eq(AgendaCreationProcess::STEP_COURSE_SELECTION) }
      end
    end

    context "with multiple steps" do
      before { agenda.filter_groups = true }

      {
        one: AgendaCreationProcess::STEP_COURSE_SELECTION,
        AgendaCreationProcess::STEP_COURSE_SELECTION => AgendaCreationProcess::STEP_COURSE_SELECTION,
        AgendaCreationProcess::STEP_GROUP_SELECTION => AgendaCreationProcess::STEP_GROUP_SELECTION,
      }.each do |step, expected_step|
        context "with step '#{step}'" do
          before { process.step = step }
          specify { expect(process.step).to eq(expected_step) }
        end
      end
    end
  end
end
