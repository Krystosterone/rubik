class DonationsController < ApplicationController
  layout false

  def new
    @donation = Donation.new
  end

  def create
    @donation = Donation.new(donation_params)

    if @donation.save
      redirect_to new_donation_path, flash: { notice: t(".success") }
    else
      render :new
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:donator_email, :amount, :message)
  end
end
