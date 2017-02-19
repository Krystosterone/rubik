# frozen_string_literal: true
module Admin
  class SidekiqSessionsController < ApplicationController
    before_action :ensure_valid_user, only: :create

    delegate :sidekiq_user_emails, to: "Rails.application.config"

    def create
      session[SidekiqSession::NAME] = true
      redirect_to admin_sidekiq_web_path
    end

    def destroy
      session[SidekiqSession::NAME] = false
      redirect_to root_path
    end

    private

    def ensure_valid_user
      redirect_to unauthorized_path unless valid_user?
    end

    def valid_user?
      omniauth_email.in?(sidekiq_user_emails)
    end

    def omniauth_email
      request.env.dig("omniauth.auth", "info", "email")
    end
  end
end
