Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end

  reload_models_for_serialization = proc do
    Dir[Rails.root.join("app/models/**/*.rb")].each { |file| require_dependency(file) }
  end

  config.after_initialize(&reload_models_for_serialization)
  config.to_prepare(&reload_models_for_serialization)
  config.comment_email_recipient = "email@development.com"
end
