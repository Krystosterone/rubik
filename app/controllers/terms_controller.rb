class TermsController < ApplicationController
  before_action :assign_terms

  decorates_assigned :terms

  def index
    @newsletter_subscription = NewsletterSubscription.new
  end

  def create_newsletter_subscription
    @newsletter_subscription = NewsletterSubscription.new(newsletter_subscription_params)

    if @newsletter_subscription.save
      redirect_to root_path, flash: { notice: t(".success") }
    else
      render :index
    end
  end

  private

  def assign_terms
    @terms = Term.includes(:academic_degree_terms, academic_degree_terms: :academic_degree).enabled.all
  end

  def newsletter_subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
