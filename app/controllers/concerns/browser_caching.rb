# frozen_string_literal: true
module BrowserCaching
  extend ActiveSupport::Concern

  private

  def invalidate_browser_cache
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
