class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :assign_donation,
                :show_navigation

  private

  def assign_donation
    @donation = Donation.new
  end

  def show_navigation
    @show_navigation = true
  end
end
