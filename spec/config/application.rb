require "rails_helper"

describe Rubik::Application do
  describe ".config.exceptions_app" do
    it "returns routes" do
      expect(described_class.config.exceptions_app).to eq(described_class.routes)
    end
  end
end
