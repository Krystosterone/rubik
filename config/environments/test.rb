# frozen_string_literal: true

Rails.application.configure do
  config.x.contributors = [Contributor.new("potato", "profile.com", "image.com")]

  config.cache_classes = true
  config.eager_load = false
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.cache_store = :null_store
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_caching = false

  config.active_support.test_order = :random
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  config.after_initialize { Bullet.raise = true }
end
