# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.compile = false
  config.active_storage.service = :local

  config.log_level = :debug
  config.log_tags = [:request_id]

  config.assets.js_compressor = :uglifier

  config.assets.digest = true

  config.action_mailer.perform_caching = false
  config.action_mailer.smtp_settings = {
    address: "smtp.sendgrid.net",
    port: "587",
    authentication: :plain,
    user_name: ENV.fetch("SENDGRID_USERNAME", nil),
    password: ENV.fetch("SENDGRID_PASSWORD", nil),
    domain: "heroku.com",
    enable_starttls_auto: true
  }

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  config.active_support.disallowed_deprecation = :log
  config.active_support.disallowed_deprecation_warnings = []

  config.log_formatter = ::Logger::Formatter.new

  config.active_record.dump_schema_after_migration = false

  config.after_initialize { Bullet.airbrake = true }
  config.read_encrypted_secrets = true

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
