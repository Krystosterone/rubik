require "sidekiq"
require "sidekiq/web"

if Rails.env.development?
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
elsif Rails.env.production?
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV.fetch("SIDEKIQ_USERNAME"), ENV.fetch("SIDEKIQ_PASSWORD")]
  end
end
