# frozen_string_literal: true
require "rails_helper"

describe SchedulesController do
  [:index, :processing].each do |action|
    describe "##{action}" do
      context "when the agenda is not found" do
        it "raises an exception" do
          expect { get action, params: { agenda_token: "1" } }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "#index" do
    context "when the agenda is still processing" do
      let(:agenda) { create(:processing_agenda) }
      before { get :index, params: { agenda_token: agenda.token } }

      it { is_expected.to redirect_to(action: :processing) }
    end

    context "when the agenda is empty" do
      let(:agenda) { create(:combined_empty_agenda) }
      before { get :index, params: { agenda_token: agenda.token } }

      it { is_expected.to redirect_to(edit_agenda_path(token: agenda.token)) }

      it "has a blank flash notice" do
        expect(flash[:notice]).to eq(I18n.t("schedules.index.blank_agenda"))
      end
    end

    context "when the agenda is found" do
      let(:agenda) { create(:combined_agenda) }
      let(:assigned_schedules) { assigns(:schedules) }
      before { get :index, params: { agenda_token: agenda.token } }

      it "assigns the agenda" do
        expect(assigns(:agenda)).to eq(agenda)
      end

      it "assigns the schedules from that agenda" do
        expect(assigned_schedules).to eq(agenda.schedules)
      end

      it { is_expected.to render_template(:index) }
    end

    context "when a page is set" do
      let(:agenda) { create(:combined_agenda) }
      let(:assigned_schedules) { assigns(:schedules) }
      before { get :index, params: { agenda_token: agenda.token, page: 1 } }

      it "assigns the schedules" do
        expect(assigned_schedules).to eq(agenda.schedules)
      end

      it "sets the correct current page" do
        expect(assigned_schedules.current_page).to eq(1)
      end

      it "sets the correct limit value" do
        expect(assigned_schedules.limit_value).to eq(20)
      end
    end

    context "when a page is set beyond limit" do
      let(:agenda) { create(:combined_agenda) }
      let(:assigned_schedules) { assigns(:schedules) }

      it "assigns the paginated schedules" do
        expect { get :index, params: { agenda_token: agenda.token, page: 2 } }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#show" do
    let(:schedules) { build_list(:schedule, 5) }
    let(:agenda) { create(:combined_agenda, schedules: schedules) }

    context "when the schedule does not exist" do
      it "raises an error" do
        expect { get :show, params: { agenda_token: agenda.token, index: 6 } }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context "when passing in an index" do
      let(:assigned_schedule) { assigns(:schedule) }
      before do
        get :show, params: { agenda_token: agenda.token, index: 3 }
      end

      it { is_expected.to render_template(:show) }

      it "assigns the correct schedule" do
        expect(assigned_schedule).to eq(agenda.schedules[2])
      end
    end
  end

  describe "#processing" do
    context "when the agenda is still processing" do
      subject { get :processing, params: { agenda_token: agenda.token } }
      let(:agenda) { create(:processing_agenda) }

      it { is_expected.to render_template(:processing) }

      it { is_expected.to have_http_status(:accepted) }
    end

    context "when the agenda finished processing" do
      subject { get :processing, params: { agenda_token: agenda.token } }
      let(:agenda) { create(:combined_agenda) }

      it { is_expected.to redirect_to(action: :index) }
    end
  end
end
