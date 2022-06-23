# frozen_string_literal: true

require "rails_helper"

describe NewsletterSubscriptionMailer do
  describe "#update_available_email" do
    subject { described_class.update_available_email(to: user, terms: terms) }

    let(:user) { build(:user) }
    let(:terms) { build_list(:term, 3) }

    its(:body) { is_expected.to include(terms.first.name) }
    its(:from) { is_expected.to include("no-reply@rubik.co") }
    its(:subject) { is_expected.to eq("Nouveaux Trimestres Disponibles") }
    its(:to) { is_expected.to include(user.email) }
  end
end
