require 'rails_helper'

describe AgendasController do
  {
    get: :new,
    post: :create,
  }.each do |method, action|
    describe "##{action}" do
      context 'when the academic degree term does not exist' do
        it 'raises an error' do
          expect { public_send method, action, academic_degree_term_id: 1 }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  {
    get: :edit,
    post: :update,
  }.each do |method, action|
    describe "##{action}" do
      context 'when the agenda does not exist' do
        it 'raises an error' do
          expect { public_send method, action, token: 1 }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe '#new' do
    context 'when the academic degree term does exist' do
      let(:academic_degree_term) { create(:academic_degree_term) }
      before { get :new, academic_degree_term_id: academic_degree_term.id }

      it { is_expected.to render_template(:edit) }

      it 'assigns a new agenda' do
        new_agenda = assigns(:agenda)

        expect(new_agenda).to be_new_record
        expect(new_agenda).to be_instance_of(Agenda)
        expect(new_agenda.academic_degree_term).to eq(academic_degree_term)
      end
    end
  end

  describe '#edit' do
    context 'when the agenda is found' do
      let(:agenda) { create(:combined_agenda) }
      before { get :edit, token: agenda.token }

      it { is_expected.to render_template(:edit) }

      it 'assigns a new agenda' do
        expect(assigns(:agenda)).to eq(agenda)
      end
    end
  end

  describe '#create' do
    context 'when the academic degree term does exist' do
      let(:academic_degree_term) { create(:academic_degree_term) }

      context 'when the post does not contain agenda' do
        it 'raises an error' do
          expect { post :create, academic_degree_term_id: academic_degree_term.id }
            .to raise_error(ActionController::ParameterMissing)
        end
      end

      context 'when the agenda could not be combined' do
        before do
          allow_any_instance_of(Agenda).to receive(:combine).and_return(false)
          post :create,
               academic_degree_term_id: academic_degree_term.id,
               agenda: { courses_per_schedule: 5 }
        end
        let(:assigned_agenda) { assigns(:agenda) }

        it { is_expected.to render_template(:edit) }

        it 'assigns the agenda with the right parameters' do
          expect(assigned_agenda).to be_new_record
          expect(assigned_agenda).to be_instance_of(Agenda)
          expect(assigned_agenda.academic_degree_term).to eq(academic_degree_term)
          expect(assigned_agenda.courses_per_schedule).to eq(5)
        end
      end

      context 'when the agenda was able to be combined' do
        let(:agenda) { Agenda.last }
        let(:course) { create(:academic_degree_term_course, academic_degree_term: academic_degree_term) }
        let(:serialized_course) { AgendaCourse.from(course) }
        before do
          post :create,
               academic_degree_term_id: academic_degree_term.id,
               agenda: { course_ids: [course.id],
                         courses_per_schedule: 1 }
        end

        it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

        it 'creates an agenda' do
          expect(agenda).not_to be_nil
          expect(agenda.academic_degree_term).to eq(academic_degree_term)

          expect(agenda.courses_per_schedule).to eq(1)
          expect(agenda.courses.size).to eq(1)
          expect(agenda.courses[0]).to eq(serialized_course)
        end
      end
    end
  end

  describe '#update' do
    let(:agenda) { create(:combined_agenda) }

    context 'when the post does not contain agenda' do
      it 'raises an error' do
        expect { post :update, token: agenda.token }
          .to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'when the agenda could not be combined' do
      before do
        allow_any_instance_of(Agenda).to receive(:combine).and_return(false)
        post :update,
             token: agenda.token,
             agenda: { courses_per_schedule: 5 }
      end
      let(:assigned_agenda) { assigns(:agenda) }

      it { is_expected.to render_template(:edit) }

      it 'assigns the agenda with the right parameters' do
        expect(assigned_agenda).to eq(agenda)
        expect(assigned_agenda.courses_per_schedule).to eq(5)
      end
    end

    context 'when the agenda was able to be combined' do
      let(:course) { create(:academic_degree_term_course, academic_degree_term: build(:academic_degree_term)) }
      let(:serialized_course) { AgendaCourse.from(course) }
      before do
        post :update,
             token: agenda.token,
             agenda: { course_ids: [course.id],
                       courses_per_schedule: 1 }
        agenda.reload
      end

      it { is_expected.to redirect_to(processing_agenda_schedules_path(agenda)) }

      it 'updates the agenda' do
        expect(agenda.courses_per_schedule).to eq(1)
        expect(agenda.courses.size).to eq(1)
        expect(agenda.courses[0]).to eq(serialized_course)
      end
    end
  end
end
