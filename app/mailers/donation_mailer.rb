class DonationMailer < BaseMailer
  def email(donation)
    @donation = donation
    send_email_to_recipient from: @donation.donator_email
  end
end
