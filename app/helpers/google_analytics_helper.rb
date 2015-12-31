module GoogleAnalyticsHelper
  delegate :ga_tracking_id, to: 'Rails.application.config'
end
