# frozen_string_literal: true
require "rails_helper"

describe NewsletterSubscriptionMailer do
  context "#update_available_email" do
    subject { described_class.update_available_email(to: "subscription@example.com", trimesters: ["This Trimester"]) }

    its(:body) { is_expected.to include("This Trimester") }
    its(:from) { is_expected.to include("no-reply@rubik.co") }
    its(:subject) { is_expected.to eq("Nouveau Trimestre Disponible") }
    its(:to) { is_expected.to include("subscription@example.com") }
  end
end
