# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch("GOOGLE_OAUTH_CLIENT_ID"),
           ENV.fetch("GOOGLE_OAUTH_CLIENT_SECRET"),
           path_prefix: "/admin/auth"
end
