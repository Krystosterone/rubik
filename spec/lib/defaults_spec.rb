# frozen_string_literal: true
require "rails_helper"

describe Defaults do
  subject { TestStudent.new }

  describe ".default" do
    its(:name) { is_expected.to eq("Krystian") }
    its(:token) { is_expected.to be_present }
  end
end
