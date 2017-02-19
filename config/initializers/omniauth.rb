# frozen_string_literal: true
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch("SIDEKIQ_OAUTH_CLIENT_ID"),
           ENV.fetch("SIDEKIQ_OAUTH_CLIENT_SECRET"),
           name: SidekiqAuthentication::AUTH_PROVIDER_NAME,
           path_prefix: "/admin/auth"
end
