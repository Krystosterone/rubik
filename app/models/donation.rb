class Donation < ActiveRecord::Base
  after_commit :send_email, on: :create

  validates :donator_email, email: true
  validates :amount, numericality: true

  private

  def send_email
    DonationMailer.email(self).deliver_later
  end
end
