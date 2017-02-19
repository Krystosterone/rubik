# frozen_string_literal: true
require "fakeredis/rspec"

redis_connection = proc { Redis.new }

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 1, &redis_connection)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 1, &redis_connection)
end
