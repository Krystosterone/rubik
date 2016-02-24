class BaseMailer < ActionMailer::Base
  protected

  def send_email_to_recipient(from:)
    mail from: from, to: Rails.application.config.email_recipient
  end
end
