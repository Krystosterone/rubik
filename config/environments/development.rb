# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_caching = false
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_storage.service = :local
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.quiet = true
  config.assets.raise_runtime_errors = true

  if Rails.root.join("tmp", "caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.after_initialize do
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end

  reload_models_for_serialization = proc do
    Dir[Rails.root.join("app", "models", "**", "*.rb")].each { |file| require_dependency(file) }
  end

  config.after_initialize(&reload_models_for_serialization)
  config.to_prepare(&reload_models_for_serialization)

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
