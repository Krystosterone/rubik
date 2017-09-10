# frozen_string_literal: true
require "rails_helper"

describe AgendasController do
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
      let(:term) { academic_degree_term.term }
      let(:agenda) { assigns(:agenda) }
      let(:academic_degree_terms) { assigns(:academic_degree_terms) }
      before { get :new, params: { term_name: term.name, term_year: term.year } }

      it { is_expected.to render_template("agendas/filter_selection") }

      it "assigns a new agenda" do
        expect(agenda).to be_a_new(Agenda)
      end

      it "assigns academic degree terms" do
        expect(academic_degree_terms).to eq([academic_degree_term])
      end
    end
  end

  describe "#edit" do
    let(:agenda) { create(:combined_agenda, filter_groups: true) }
    let(:academic_degree_term) { agenda.academic_degree_term }
    let(:assigned_academic_degree_terms) { assigns(:academic_degree_terms) }

    context "when the agenda is found with no step" do
      before { get :edit, params: { token: agenda.token } }

      it { is_expected.to render_template("agendas/filter_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end

      it "assigns academic degree terms" do
        expect(assigned_academic_degree_terms).to eq([academic_degree_term])
      end
    end

    context "when the agenda is found with step 'filter_selection'" do
      before { get :edit, params: { step: AgendaCreationProcess::STEP_FILTER_SELECTION, token: agenda.token } }

      it { is_expected.to render_template("agendas/filter_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end

      it "assigns academic degree terms" do
        expect(assigned_academic_degree_terms).to eq([academic_degree_term])
      end
    end

    context "when the agenda is found with step 'course_selection'" do
      before { get :edit, params: { step: AgendaCreationProcess::STEP_COURSE_SELECTION, token: agenda.token } }

      it { is_expected.to render_template("agendas/course_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end

    context "when the agenda is found with step 'group_selection'" do
      before { get :edit, params: { step: AgendaCreationProcess::STEP_GROUP_SELECTION, token: agenda.token } }

      it { is_expected.to render_template("agendas/group_selection") }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end
  end

  describe "#create" do
    let(:academic_degree_term) { create(:academic_degree_term) }
    let(:assigned_academic_degree_terms) { assigns(:academic_degree_terms) }
    let(:assigned_agenda) { assigns(:agenda) }
    let(:created_agenda) { Agenda.last }
    let(:term) { academic_degree_term.term }

    context "when the agenda is not valid" do
      before { post :create, params: { term_name: term.name, term_year: term.year } }

      it { is_expected.to render_template("agendas/filter_selection") }

      specify { expect(assigned_agenda).to be_a_new(Agenda) }

      it "assigns academic degree terms" do
        expect(assigned_academic_degree_terms).to eq([academic_degree_term])
      end
    end

    context "when the agenda is valid" do
      before do
        post :create, params: {
          agenda: {
            agenda_term_tags_attributes: {
              0 => { term_tag_id: Base64.encode64("scope:term;value:#{term.tags}") },
              1 => { term_tag_id: Base64.encode64("scope:academic_degree;value:#{academic_degree_term.code}") },
            },
          },
          term_name: term.name,
          term_year: term.year,
        }
      end

      it "creates an agenda" do
        expect(assigned_agenda).to eq(created_agenda)
      end

      it do
        is_expected.to redirect_to(edit_agenda_path(created_agenda, step: AgendaCreationProcess::STEP_COURSE_SELECTION))
      end
    end
  end

  describe "#update" do
    let(:academic_degree_term) { create(:academic_degree_term) }
    let(:agenda) { create(:combined_agenda) }
    let(:assigned_agenda) { assigns(:agenda) }
    let(:term) { academic_degree_term.term }

    context "when on the 'filter_selection' step" do
      before do
        put :update, params: {
          agenda: {
            agenda_term_tags_attributes: {
              0 => { term_tag_id: Base64.encode64("scope:term;value:#{term.tags}") },
              1 => { term_tag_id: Base64.encode64("scope:academic_degree;value:#{academic_degree_term.code}") },
            },
          },
          term_name: term.name,
          term_year: term.year,
          token: agenda.token,
        }
        agenda.reload
      end

      it "updates the agenda" do
        expect(agenda.academic_degree_term).to eq(academic_degree_term)
      end

      it do
        is_expected.to redirect_to(edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_COURSE_SELECTION))
      end
    end

    context "when on the 'course_selection' step" do
      let(:academic_degree_term_course) do
        create(:academic_degree_term_course, academic_degree_term: agenda.academic_degree_term)
      end
      let(:courses_attributes) do
        courses_attributes = agenda.courses.map { |course| { id: course.id, _destroy: "1" } }
        courses_attributes << { academic_degree_term_course_id: academic_degree_term_course.id, mandatory: true }
        courses_attributes.map.with_index { |attributes, index| [index, attributes] }.to_h
      end

      context "with invalid params" do
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

        it "assigns the agenda" do
          expect(assigned_agenda).to eq(agenda)
        end
      end

      context "with no group filtering" do
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

      context "with group filtering" do
        before do
          put :update, params: {
            agenda: {
              courses_attributes: courses_attributes,
              courses_per_schedule: 1,
              filter_groups: true,
              leaves_attributes: {
                0 => { starts_at: 0, ends_at: 100 },
              },
            },
            token: agenda.token,
            step: AgendaCreationProcess::STEP_COURSE_SELECTION,
          }
          agenda.reload
        end

        it { is_expected.to redirect_to(edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_GROUP_SELECTION)) }

        it { expect(agenda.courses_per_schedule).to eq(1) }
      end
    end

    context "when on the 'group_selection' step" do
      let(:group_numbers) { Array(agenda.courses.first.group_numbers.first) }
      before do
        agenda.update!(filter_groups: true)
        put :update, params: {
          agenda: {
            courses_attributes: {
              0 => {
                id: agenda.courses.first.id,
                group_numbers: group_numbers,
              }
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
