# frozen_string_literal: true
require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rubik
  class Application < Rails::Application
    config.i18n.available_locales = [:fr]
    config.i18n.default_locale = :fr
    config.i18n.enforce_available_locales = true

    config.action_mailer.preview_path = Rails.root.join("spec", "mailers", "previews")
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += %W(
      #{config.root}/lib
    )

    config.browserify_rails.commandline_options = "-t babelify"
    config.browserify_rails.source_map_environments << "development"

    config.exceptions_app = routes
    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }
    config.admin_emails = ENV.fetch("ADMIN_EMAILS").split(",")
    config.ga_tracking_id = ENV.fetch("GA_ANALYTICS_ID")
    config.comment_email_recipient = ENV.fetch("COMMENT_EMAIL_RECIPIENT")

    config.after_initialize do
      Bullet.enable = true
      Bullet.bullet_logger = true
      Bullet.rails_logger = true
    end
  end
end
