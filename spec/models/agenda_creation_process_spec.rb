# frozen_string_literal: true

require "rails_helper"

describe AgendaCreationProcess do
  subject(:process) { described_class.new(agenda: agenda) }

  let(:agenda) { build(:agenda) }

  describe "#path" do
    context "with a single step" do
      before { agenda.filter_groups = false }

      specify { expect(process.path).to eq("/agendas/#{agenda.token}/schedules/processing") }
    end

    context "with multiple steps" do
      before { agenda.filter_groups = true }

      context "when on the first step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }

        specify { expect(process.path).to eq("/agendas/#{agenda.token}/edit?step=group_selection") }
      end

      context "when on the last step" do
        before { process.step = AgendaCreationProcess::STEP_GROUP_SELECTION }

        specify { expect(process.path).to eq("/agendas/#{agenda.token}/schedules/processing") }
      end
    end
  end

  describe "#save" do
    shared_examples "an unsuccessful save" do
      before { agenda.courses_per_schedule = 99 }

      specify { expect(process.save).to be(false) }
    end

    shared_examples "a successful save with no generation" do
      specify { expect(process.save).to be(true) }
      specify { expect { process.save }.not_to(change(agenda, :processing)) }
      specify { expect { process.save }.not_to(change(agenda, :combined_at)) }
    end

    shared_examples "a successful agenda generation" do
      specify { expect(process.save).to be(true) }
      specify { expect { process.save }.to change(agenda, :processing).to be(true) }

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
      let(:group_numbers) { agenda.courses.map { |course| course.academic_degree_term_course.group_numbers } }
      before { agenda.courses.each { |course| course.group_numbers = [] } }

      it "resets the group numbers of the courses" do
        expect { process.save }.to change { agenda.courses.map(&:group_numbers) }.to eq(group_numbers)
      end
    end

    context "with a single step" do
      before { agenda.filter_groups = false }

      it_behaves_like "an unsuccessful save"
      it_behaves_like "a reset of course group numbers"
      it_behaves_like "a successful agenda generation"
    end

    context "with multiple steps" do
      context "when on the first step" do
        before { process.step = AgendaCreationProcess::STEP_COURSE_SELECTION }

        context "with a new agenda" do
          let(:agenda) { build(:agenda, filter_groups: true) }

          it_behaves_like "an unsuccessful save"
          it_behaves_like "a successful save with no generation"
          it_behaves_like "a reset of course group numbers"
        end

        context "with an existing agenda" do
          let(:agenda) { create(:combined_agenda, filter_groups: true) }

          it_behaves_like "an unsuccessful save"
          it_behaves_like "a successful save with no generation"
        end
      end

      context "when on the last step" do
        before do
          process.step = AgendaCreationProcess::STEP_GROUP_SELECTION
          agenda.filter_groups = true
        end

        it_behaves_like "an unsuccessful save"
        it_behaves_like "a successful agenda generation"
      end
    end
  end

  describe "#step" do
    context "with a single step" do
      %i[one two].each do |step|
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
