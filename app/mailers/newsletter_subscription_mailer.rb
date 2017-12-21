# frozen_string_literal: true

class NewsletterSubscriptionMailer < ApplicationMailer
  default from: "no-reply@rubik.co"
  helper TrimestersHelper

  def update_available_email(to:, trimesters:)
    @trimesters = trimesters
    mail subject: t(".subject", count: trimesters.count), to: to
  end
end
