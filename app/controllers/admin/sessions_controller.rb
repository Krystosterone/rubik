# frozen_string_literal: true
module Admin
  class SessionsController < ApplicationController
    before_action :ensure_valid_user, only: :create

    delegate :admin_emails, to: "Rails.application.config"

    def create
      session[AdminSession::NAME] = true
      redirect_to admin_root_path
    end

    def destroy
      session[AdminSession::NAME] = false
      redirect_to root_path
    end

    private

    def ensure_valid_user
      redirect_to unauthorized_path unless valid_user?
    end

    def valid_user?
      omniauth_email.in?(admin_emails)
    end

    def omniauth_email
      request.env.dig("omniauth.auth", "info", "email")
    end
  end
end
