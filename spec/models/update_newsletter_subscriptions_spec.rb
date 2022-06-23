# frozen_string_literal: true

require "rails_helper"

describe UpdateNewsletterSubscriptions do
  subject(:service) { described_class.new(terms: terms) }

  let(:mailers) { users.map { instance_double(ActionMailer::MessageDelivery) } }
  let(:users) { create_list(:user, 3) }
  let(:terms) { create_list(:term, 3) }

  before do
    users.each_with_index do |user, index|
      allow(NewsletterSubscriptionMailer).to receive(:update_available_email)
        .with(to: user, terms: terms).and_return(mailers[index])
    end

    mailers.each { |mailer| allow(mailer).to receive(:deliver_later) }
  end

  describe "#call" do
    it "sends an update email to all newsletter subscribers" do
      service.call

      expect(mailers).to all(have_received(:deliver_later))
    end
  end
end
