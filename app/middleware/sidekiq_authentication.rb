# frozen_string_literal: true
class SidekiqAuthentication
  include Rails.application.routes.url_helpers

  AUTH_PROVIDER_NAME = "sidekiq"

  def initialize(app)
    @app = app
  end

  def call(env)
    if active_sidekiq_session?(env)
      @app.call(env)
    else
      redirect_to sidekiq_signin_path
    end
  end

  private

  def active_sidekiq_session?(env)
    Rack::Request.new(env).session[SidekiqSession::NAME]
  end

  def redirect_to(path)
    [302, { "Location" => path }, []]
  end
end
