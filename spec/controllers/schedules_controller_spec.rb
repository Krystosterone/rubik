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

  describe '#index' do
    context "when the agenda is still processing" do
      let(:agenda) { double(Agenda, processing?: true) }
      before do
        allow(Agenda).to receive(:find_by!).with(token: "a_token").and_return(agenda)
        get :index, params: { agenda_token: "a_token" }
      end

      it { is_expected.to redirect_to(action: :processing) }
    end

    context "when the agenda is empty" do
      let(:agenda) { double(Agenda, token: "a_token", processing?: false, empty?: true) }
      before do
        allow(Agenda).to receive(:find_by!).with(token: agenda.token).and_return(agenda)
        get :index, params: { agenda_token: agenda.token }
      end

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

    context "when a page is past in" do
      let(:schedules) { double }
      let(:agenda) { double(Agenda, schedules: schedules, processing?: false, empty?: false) }
      before do
        allow(Agenda).to receive(:find_by!).with(token: "a_token").and_return(agenda)
        allow(schedules).to receive(:page).with("10").and_return(schedules)
        allow(schedules).to receive(:per).with(ScheduleHelper::SCHEDULES_PER_PAGE).and_return(schedules)

        get :index, params: { agenda_token: "a_token", page: 10 }
      end

      it "assigns the paginated schedules" do
        expect(schedules).to eq(agenda.schedules)
      end
    end
  end

  describe '#processing' do
    before { allow(Agenda).to receive(:find_by!).with(token: "a_token").and_return(agenda) }

    context "when the agenda is still processing" do
      let(:agenda) { double(processing?: true) }
      before { get :processing, params: { agenda_token: "a_token" } }

      it { is_expected.to render_template(:processing) }
    end

    context "when the agenda finished processing" do
      let(:agenda) { double(processing?: false) }
      before { get :processing, params: { agenda_token: "a_token" } }

      it { is_expected.to redirect_to(action: :index) }
    end
  end
end
