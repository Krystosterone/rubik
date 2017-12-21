# frozen_string_literal: true

require "rails_helper"

describe NewsletterSubscription do
  it { is_expected.to allow_value("test@domain.com").for(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
end
