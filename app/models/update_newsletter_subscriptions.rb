# frozen_string_literal: true

class UpdateNewsletterSubscriptions
  include ActiveModel::Model

  attr_accessor :terms

  def call
    subscriptions.each do |subscription|
      NewsletterSubscriptionMailer
        .update_available_email(to: subscription, terms: terms)
        .deliver_later
    end
  end

  private

  def subscriptions
    User.subscribed_to_newsletter
  end
end
