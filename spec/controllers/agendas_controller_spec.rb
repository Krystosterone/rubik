# frozen_string_literal: true
require "rails_helper"

describe AgendasController do
  {
    get: :new,
    post: :create,
  }.each do |method, action|
    describe "##{action}" do
      context "when the academic degree term does not exist" do
        it "raises an error" do
          expect { public_send method, action, params: { academic_degree_term_id: 1 } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  {
    get: :edit,
    post: :update,
  }.each do |method, action|
    describe "##{action}" do
      context "when the agenda is still processing" do
        let(:agenda) { create(:processing_agenda) }
        before { public_send method, action, params: { token: agenda.token } }

        it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda.token)) }
      end

      context "when the agenda does not exist" do
        it "raises an error" do
          expect { public_send method, action, params: { token: 1 } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "#new" do
    context "when the academic degree term does exist" do
      let(:academic_degree_term) { create(:academic_degree_term) }
      let(:agenda) { assigns(:agenda) }
      before { get :new, params: { academic_degree_term_id: academic_degree_term.id } }

      it { is_expected.to render_template("agendas/course_selection") }

      it "assigns a new agenda" do
        expect(agenda).to be_a_new(Agenda)
      end

      specify { expect(agenda.academic_degree_term).to eq(academic_degree_term) }
    end
  end

  describe "#edit" do
    context "when the agenda is found with no step" do
      let(:agenda) { create(:combined_agenda) }
      before { get :edit, params: { token: agenda.token } }

      it { is_expected.to render_template("agendas/course_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end

    context "when the agenda is found with step 'course_selection'" do
      let(:agenda) { create(:combined_agenda) }
      before { get :edit, params: { step: AgendaCreationProcess::STEP_COURSE_SELECTION, token: agenda.token } }

      it { is_expected.to render_template("agendas/course_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end

    context "when the agenda is found with step 'group_selection'" do
      let(:agenda) { create(:combined_agenda, filter_groups: true) }
      before { get :edit, params: { step: AgendaCreationProcess::STEP_GROUP_SELECTION, token: agenda.token } }

      it { is_expected.to render_template("agendas/group_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end
  end

  describe "#create" do
    let(:academic_degree_term) { create(:academic_degree_term) }

    context "when the post does not contain agenda" do
      it "raises an error" do
        expect { post :create, params: { academic_degree_term_id: academic_degree_term.id } }
          .to raise_error(ActionController::ParameterMissing)
      end
    end

    context "when no group filtering was selected" do
      context "when the agenda could not be saved" do
        let(:assigned_agenda) { assigns(:agenda) }
        before do
          post :create, params: {
            academic_degree_term_id: academic_degree_term.id,
            agenda: {
              courses_per_schedule: 6,
              filter_groups: false,
            },
          }
        end

        it { is_expected.to render_template("agendas/course_selection") }

        specify { expect(assigned_agenda).to be_a_new(Agenda) }
        specify { expect(assigned_agenda.academic_degree_term).to eq(academic_degree_term) }
        specify { expect(assigned_agenda.courses_per_schedule).to eq(6) }
      end

      context "when the agenda was saved" do
        let(:agenda) { Agenda.last }
        let(:academic_degree_term_course) do
          create(:academic_degree_term_course, academic_degree_term: academic_degree_term)
        end
        before do
          post :create, params: {
            academic_degree_term_id: academic_degree_term.id,
            agenda: {
              courses_attributes: {
                0 => { academic_degree_term_course_id: academic_degree_term_course.id, mandatory: true },
              },
              courses_per_schedule: 1,
              filter_groups: false,
              leaves_attributes: {
                0 => { starts_at: 0, ends_at: 100 },
              },
            },
          }
        end

        it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

        it "creates an agenda" do
          expect(agenda).to be_present
        end

        it "enqueues the job to combine schedules" do
          expect(ScheduleGeneratorJob).to have_been_enqueued.with(global_id(agenda))
        end
      end
    end

    context "when group filtering was selected" do
      context "when the agenda could not be saved" do
        let(:assigned_agenda) { assigns(:agenda) }
        before do
          post :create, params: {
            academic_degree_term_id: academic_degree_term.id,
            agenda: {
              courses_per_schedule: 6,
              filter_groups: true,
            },
          }
        end

        it { is_expected.to render_template("agendas/course_selection") }

        specify { expect(assigned_agenda).to be_a_new(Agenda) }
        specify { expect(assigned_agenda.academic_degree_term).to eq(academic_degree_term) }
        specify { expect(assigned_agenda.courses_per_schedule).to eq(6) }
      end

      context "when the agenda was saved" do
        let(:agenda) { Agenda.last }
        let(:academic_degree_term_course) do
          create(:academic_degree_term_course, academic_degree_term: academic_degree_term)
        end
        before do
          post :create, params: {
            academic_degree_term_id: academic_degree_term.id,
            agenda: {
              courses_attributes: {
                0 => { academic_degree_term_course_id: academic_degree_term_course.id, mandatory: true },
              },
              courses_per_schedule: 1,
              filter_groups: true,
              leaves_attributes: {
                0 => { starts_at: 0, ends_at: 100 },
              },
            },
          }
        end

        it { is_expected.to redirect_to(edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_GROUP_SELECTION)) }

        it "creates an agenda" do
          expect(agenda).to be_present
        end
      end
    end
  end

  describe "#update" do
    let(:agenda) { create(:combined_agenda) }

    context "when the post does not contain agenda" do
      it "raises an error" do
        expect { post :update, params: { token: agenda.token } }
          .to raise_error(ActionController::ParameterMissing)
      end
    end

    context "when group filtering was selected on step 'course_selection'" do
      context "when the agenda could not be saved" do
        before do
          put :update, params: {
            agenda: {
              courses_per_schedule: 6,
              filter_groups: false,
            },
            token: agenda.token,
            step: AgendaCreationProcess::STEP_COURSE_SELECTION,
          }
        end

        it { is_expected.to render_template("agendas/course_selection") }

        it "assigns a new agenda" do
          expect(assigns(:agenda)).to eq(agenda)
        end
      end

      context "when the agenda was saved" do
        let(:academic_degree_term_course) do
          create(:academic_degree_term_course, academic_degree_term: agenda.academic_degree_term)
        end
        let(:courses_attributes) do
          courses_attributes = agenda.courses.map { |course| { id: course.id, _destroy: "1" } }
          courses_attributes << { academic_degree_term_course_id: academic_degree_term_course.id, mandatory: true }
          courses_attributes.map.with_index { |attributes, index| [index, attributes] }.to_h
        end
        before do
          put :update, params: {
            agenda: {
              courses_attributes: courses_attributes,
              courses_per_schedule: 1,
              filter_groups: false,
              leaves_attributes: {
                0 => { starts_at: 0, ends_at: 100 },
              },
            },
            token: agenda.token,
            step: AgendaCreationProcess::STEP_COURSE_SELECTION,
          }
          agenda.reload
        end

        it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

        it { expect(agenda.courses_per_schedule).to eq(1) }
      end
    end

    context "when no group filtering was selected on step 'group_selection'" do
      before { agenda.update!(filter_groups: true) }

      context "when the agenda could not be saved" do
        before do
          put :update, params: {
            agenda: {
              courses_attributes: {
                id: agenda.courses.first.id,
                group_numbers: [""],
              }
            },
            token: agenda.token,
            step: AgendaCreationProcess::STEP_GROUP_SELECTION,
          }
        end

        it { is_expected.to render_template("agendas/group_selection") }

        it "assigns a new agenda" do
          expect(assigns(:agenda)).to eq(agenda)
        end
      end

      context "when the agenda was saved" do
        let(:group_numbers) { Array(agenda.courses.first.groups.first.number) }
        before do
          put :update, params: {
            agenda: {
              courses_attributes: {
                id: agenda.courses.first.id,
                group_numbers: group_numbers,
              },
            },
            token: agenda.token,
            step: AgendaCreationProcess::STEP_GROUP_SELECTION,
          }
          agenda.reload
        end

        it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

        it { expect(agenda.courses.first.group_numbers).to eq(group_numbers) }
      end
    end
  end
end
