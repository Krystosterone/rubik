# frozen_string_literal: true

require "rails_helper"

describe UpdateNewsletterSubscriptions do
  subject(:service) { described_class.new(trimesters: trimesters) }

  let(:mailers) { newsletter_subscriptions.map { instance_double(ActionMailer::MessageDelivery) } }
  let(:newsletter_subscriptions) { build_list(:newsletter_subscription, 3) }
  let(:trimesters) { ["One"] }

  before do
    newsletter_subscriptions.each(&:save!)
    newsletter_subscriptions.each_with_index do |subscription, index|
      allow(NewsletterSubscriptionMailer)
        .to receive(:update_available_email)
        .with(to: subscription.email, trimesters: trimesters)
        .and_return(mailers[index])
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
