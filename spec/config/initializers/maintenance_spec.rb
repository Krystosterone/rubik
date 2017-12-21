# frozen_string_literal: true

require "rails_helper"

describe Rubik::Application do
  it "has the Maintenance middleware" do
    expect(Rails.application.middleware).to include(Maintenance)
  end
end
