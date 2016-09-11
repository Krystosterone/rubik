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

      it { is_expected.to render_template(:edit) }

      it "assigns a new agenda" do
        expect(agenda).to be_a_new(Agenda)
      end

      specify { expect(agenda.academic_degree_term).to eq(academic_degree_term) }
    end
  end

  describe "#edit" do
    context "when the agenda is found" do
      let(:agenda) { create(:combined_agenda) }
      before { get :edit, params: { token: agenda.token } }

      it { is_expected.to render_template(:edit) }

      it "assigns a new agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end
  end

  describe "#create" do
    context "when the academic degree term does exist" do
      let(:academic_degree_term) { create(:academic_degree_term) }

      context "when the post does not contain agenda" do
        it "raises an error" do
          expect { post :create, params: { academic_degree_term_id: academic_degree_term.id } }
            .to raise_error(ActionController::ParameterMissing)
        end
      end

      context "when the agenda could not be combined" do
        before do
          allow_any_instance_of(Agenda).to receive(:combine).and_return(false)
          post :create,
               params: {
                 academic_degree_term_id: academic_degree_term.id,
                 agenda: { courses_per_schedule: 5 }
               }
        end
        let(:assigned_agenda) { assigns(:agenda) }

        it { is_expected.to render_template(:edit) }

        it "assigns the agenda" do
          expect(assigned_agenda).to be_a_new(Agenda)
        end

        specify { expect(assigned_agenda.academic_degree_term).to eq(academic_degree_term) }
        specify { expect(assigned_agenda.courses_per_schedule).to eq(5) }
      end

      context "when the agenda was able to be combined" do
        let(:agenda) { Agenda.last }
        let(:course) { create(:academic_degree_term_course, academic_degree_term: academic_degree_term) }
        let(:serialized_course) { AgendaCourse.from(course) }
        before do
          post :create,
               params: {
                 academic_degree_term_id: academic_degree_term.id,
                 agenda: {
                   course_ids: [course.id],
                   courses_per_schedule: 1,
                   leaves_attributes: {
                     0 => { starts_at: 0, ends_at: 100 }
                   },
                   mandatory_course_ids: [course.id],
                 },
               }
        end

        it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

        it "creates an agenda" do
          expect(agenda).not_to be_nil
        end

        specify { expect(agenda.academic_degree_term).to eq(academic_degree_term) }
        specify { expect(agenda.courses_per_schedule).to eq(1) }
        specify { expect(agenda.courses.size).to eq(1) }
        specify { expect(agenda.courses[0]).to eq(serialized_course) }
        specify { expect(agenda.leaves.size).to eq(1) }
        specify { expect(agenda.leaves[0]).to eq(Leave.new(starts_at: 0, ends_at: 100)) }
        specify { expect(agenda.mandatory_course_ids).to eq([course.id]) }
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

    context "when the agenda could not be combined" do
      before do
        allow_any_instance_of(Agenda).to receive(:combine).and_return(false)
        post :update,
             params: {
               token: agenda.token,
               agenda: { courses_per_schedule: 5 }
             }
      end
      let(:assigned_agenda) { assigns(:agenda) }

      it { is_expected.to render_template(:edit) }

      it "assigns the agenda" do
        expect(assigned_agenda).to eq(agenda)
      end

      it "updates the attributes on the agenda" do
        expect(assigned_agenda.courses_per_schedule).to eq(5)
      end
    end

    context "when the agenda was able to be combined" do
      let(:course) { create(:academic_degree_term_course, academic_degree_term: agenda.academic_degree_term) }
      let(:serialized_course) { AgendaCourse.from(course) }
      before do
        post :update,
             params: {
               token: agenda.token,
               agenda: {
                 course_ids: [course.id],
                 courses_per_schedule: 1,
                 leaves_attributes: {
                   0 => { starts_at: 0, ends_at: 100 }
                 },
                 mandatory_course_ids: [course.id],
               }
             }
        agenda.reload
      end

      it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

      specify { expect(agenda.courses_per_schedule).to eq(1) }
      specify { expect(agenda.courses.size).to eq(1) }
      specify { expect(agenda.courses[0]).to eq(serialized_course) }
      specify { expect(agenda.leaves.size).to eq(1) }
      specify { expect(agenda.leaves[0]).to eq(Leave.new(starts_at: 0, ends_at: 100)) }
      specify { expect(agenda.mandatory_course_ids).to eq([course.id]) }
    end
  end
end
