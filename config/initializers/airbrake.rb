# frozen_string_literal: true

Airbrake.configure do |c|
  c.project_id = ENV.fetch("AIRBRAKE_PROJECT_ID")
  c.project_key = ENV.fetch("AIRBRAKE_API_KEY")
  c.root_directory = Rails.root
  c.logger = Airbrake::Rails.logger
  c.environment = Rails.env
  c.ignore_environments = %w[development test]
  c.blocklist_keys = [/password/i, /authorization/i]
end

Airbrake.add_filter do |notice|
  ignored_errors = %w[
    AbstractController::ActionNotFound
    ActionController::InvalidAuthenticityToken
    ActiveRecord::RecordNotFound
  ]
  notice.ignore! if notice[:errors].any? { |error| ignored_errors.include?(error[:type]) }
end
