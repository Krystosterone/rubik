# frozen_string_literal: true

class User < ApplicationRecord
  has_subscriptions

  NEWSLETTER_NAME = "newsletter"

  validates :email, email: true, uniqueness: true

  scope :subscribed_to_newsletter, -> { subscribed(NEWSLETTER_NAME) }

  after_create :newsletter_signup

  private

  def newsletter_signup
    subscribe(NEWSLETTER_NAME)
  end
end
