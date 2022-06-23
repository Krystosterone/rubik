# frozen_string_literal: true

class TermsController < ApplicationController
  before_action :assign_terms

  def index
    @user = User.new
  end

  def create_newsletter_subscription
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, flash: { notice: t(".success") }
    else
      render :index
    end
  end

  private

  def assign_terms
    @terms = Term.includes(:academic_degree_terms, academic_degree_terms: :academic_degree).enabled.all
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
