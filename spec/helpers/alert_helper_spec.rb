require "rails_helper"

describe AlertHelper do
  describe '#alert_class' do
    described_class::CLASSES.each do |type, css_class|
      context "with type #{type}" do
        specify { expect(alert_class(type)).to eq(css_class) }
      end
    end

    context "when the type is not defined" do
      it 'returns itself appended by "alert"' do
        expect(alert_class("potato")).to eq("alert-potato")
      end
    end
  end
end
