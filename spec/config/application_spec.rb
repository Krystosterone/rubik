# frozen_string_literal: true

require "rails_helper"

describe Rubik::Application do # rubocop:disable RSpec/FilePath
  describe ".config.exceptions_app" do
    it "returns routes" do
      expect(described_class.config.exceptions_app).to eq(described_class.routes)
    end
  end
end
