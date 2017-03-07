# frozen_string_literal: true
require "rails_helper"

describe AgendaCreationProcess do
  subject(:process) { described_class.new(agenda) }
  let(:agenda) { create(:combined_agenda) }

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
    shared_examples "a process capable of handling an unsuccessful save" do
      before { agenda.courses_per_schedule = 99 }

      specify { expect(process.save).to eq(false) }
      specify { expect { process.save }.not_to change { agenda.processing } }
      specify { expect { process.save }.not_to change { agenda.combined_at } }
    end

    shared_examples "a process capable of handling the last step" do
      it_behaves_like "a process capable of handling an unsuccessful save"

      context "with a successful save" do
        specify { expect(process.save).to eq(true) }
        specify { expect { process.save }.to change { agenda.processing }.to eq(true) }
        specify { expect { process.save }.to change { agenda.combined_at }.to be_nil }

        it "enqueues the generator job" do
          process.save

          expect(ScheduleGeneratorJob).to have_been_enqueued.with(global_id(agenda))
        end
      end
    end

    context "with a single step" do
      before { agenda.filter_groups = false }

      it_behaves_like "a process capable of handling the last step"
    end

    context "with multiple steps" do
      before { agenda.filter_groups = true }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }

        it_behaves_like "a process capable of handling an unsuccessful save"

        context "with a successful save" do
          specify { expect(process.save).to eq(true) }
          specify { expect { process.save }.not_to change { agenda.processing } }
          specify { expect { process.save }.not_to change { agenda.combined_at } }
        end
      end

      context "on the last step" do
        before { process.step = AgendaCreationProcess::STEP_GROUP_SELECTION }

        it_behaves_like "a process capable of handling the last step"
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
