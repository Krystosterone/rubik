# frozen_string_literal: true
require "rails_helper"

describe Rubik::Application do
  it "has the Maintenane middleware" do
    expect(Rails.application.middleware).to include(Maintenance)
  end
end
