require "rails_helper"

describe ScheduleHelper do
  describe '#schedule_index' do
    context "with no page defined" do
      specify { expect(schedule_index).to be_zero }
    end

    context "with page set to 0" do
      let(:params) { { page: 0 } }
      specify { expect(schedule_index).to be_zero }
    end

    context "with a page defined" do
      let(:params) { { page: 3 } }

      it "returns the page multiplied" do
        expect(schedule_index).to eq(100)
      end
    end
  end
end
