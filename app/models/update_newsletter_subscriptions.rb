# frozen_string_literal: true
class UpdateNewsletterSubscriptions
  include ActiveModel::Model

  attr_accessor :trimesters

  def call
    subscriptions.each do |subscription|
      NewsletterSubscriptionMailer
        .update_available_email(to: subscription, trimesters: trimesters)
        .deliver_later
    end
  end

  private

  def subscriptions
    NewsletterSubscription.all.pluck(:email)
  end
end
