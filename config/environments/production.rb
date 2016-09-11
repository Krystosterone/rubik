# frozen_string_literal: true
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.smtp_settings = {
    address: "smtp.sendgrid.net",
    port: "587",
    authentication: :plain,
    user_name: ENV["SENDGRID_USERNAME"],
    password: ENV["SENDGRID_PASSWORD"],
    domain: "heroku.com",
    enable_starttls_auto: true
  }
end
