# frozen_string_literal: true

Airbrake.configure do |c|
  c.project_id = ENV["AIRBRAKE_PROJECT_ID"]
  c.project_key = ENV["AIRBRAKE_API_KEY"]
  c.root_directory = Rails.root
  c.logger = Rails.logger
  c.environment = Rails.env
  c.ignore_environments = %w[development test]
end

Airbrake.add_filter do |notice|
  ignored_errors = %w[
    AbstractController::ActionNotFound
    ActionController::InvalidAuthenticityToken
    ActiveRecord::RecordNotFound
  ]
  notice.ignore! if notice[:errors].any? { |error| ignored_errors.include?(error[:type]) }
end
