# frozen_string_literal: true

class NewsletterSubscriptionMailer < ApplicationMailer
  default from: "no-reply@rubik.co"
  helper TrimestersHelper

  delegate :host, :protocol, to: "Rails.application.config.x"

  def update_available_email(to:, terms:)
    @user = to
    @terms = terms
    @link = URI::HTTP.build(host: host, protocol: protocol).to_s

    mail subject: t(".subject", count: terms.count), to: to.email
  end
end
