# frozen_string_literal: true
require "rails_helper"

describe AgendaCreationProcess do
  subject(:process) { described_class.new(agenda: agenda) }
  let(:agenda) { build(:agenda) }

  describe "#path" do
    context "with a no group filtering" do
      before { agenda.filter_groups = false }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_FILTER_SELECTION }
        specify { expect(process.path).to eq("/agendas/#{agenda.token}/edit?step=course_selection") }
      end

      context "on the last step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }
        specify { expect(process.path).to eq("/agendas/#{agenda.token}/schedules/processing") }
      end
    end

    context "with group filtering" do
      before { agenda.filter_groups = true }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_FILTER_SELECTION }
        specify { expect(process.path).to eq("/agendas/#{agenda.token}/edit?step=course_selection") }
      end

      context "on the second step" do
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
    shared_examples "an unsuccessful save" do
      before { agenda.academic_degree_term = nil }
      specify { expect(process.save).to eq(false) }
    end

    shared_examples "a successful save with no generation" do
      specify { expect(process.save).to eq(true) }
      specify { expect { process.save }.not_to change { agenda.processing } }
      specify { expect { process.save }.not_to change { agenda.combined_at } }
    end

    shared_examples "a successful agenda generation" do
      specify { expect(process.save).to eq(true) }
      specify { expect { process.save }.to change { agenda.processing }.to eq(true) }

      it "sets the combined at timestamp to nil" do
        process.save
        expect(agenda.combined_at).to be_nil
      end

      it "enqueues the generator job" do
        process.save
        expect(ScheduleGeneratorJob).to have_been_enqueued.with(global_id(agenda))
      end
    end

    shared_examples "a reset of course group numbers" do
      let(:courses) do
        build_list(:agenda_course, 3).map do |course|
          course.group_numbers = []
          course
        end
      end
      let(:group_numbers) { courses.map(&:academic_degree_term_course).map(&:group_numbers) }
      before { agenda.courses = courses }

      it "resets the group numbers of the courses" do
        expect { process.save }.to change { agenda.courses.map(&:group_numbers) }.to(group_numbers)
      end
    end

    context "with no group filtering" do
      before { agenda.filter_groups = false }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_FILTER_SELECTION }

        it_behaves_like "an unsuccessful save"
      end

      context "on the last step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }

        it_behaves_like "an unsuccessful save"
        it_behaves_like "a reset of course group numbers"
        it_behaves_like "a successful agenda generation"
      end
    end

    context "with group filtering" do
      before { agenda.filter_groups = true }

      context "on the first step" do
        before { process.step = AgendaCreationProcess::STEP_FILTER_SELECTION }

        it_behaves_like "an unsuccessful save"
      end

      context "on the second step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }

        context "with an agenda with new courses" do
          it_behaves_like "an unsuccessful save"
          it_behaves_like "a successful save with no generation"
          it_behaves_like "a reset of course group numbers"
        end

        context "with an agenda with existing courses" do
          let(:agenda) { create(:combined_agenda, filter_groups: true) }

          it_behaves_like "an unsuccessful save"
          it_behaves_like "a successful save with no generation"
        end
      end

      context "on the last step" do
        before { process.step = AgendaCreationProcess::STEP_GROUP_SELECTION }

        it_behaves_like "an unsuccessful save"
        it_behaves_like "a successful agenda generation"
      end
    end
  end

  describe "#step" do
    context "with a no group filtering" do
      [:one, :two].each do |step|
        before do
          agenda.filter_groups = false
          process.step = step
        end
        specify { expect(process.step).to eq(AgendaCreationProcess::STEP_FILTER_SELECTION) }
      end
    end

    context "with group filtering" do
      before { agenda.filter_groups = true }

      {
        one: AgendaCreationProcess::STEP_FILTER_SELECTION,
        AgendaCreationProcess::STEP_FILTER_SELECTION => AgendaCreationProcess::STEP_FILTER_SELECTION,
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
