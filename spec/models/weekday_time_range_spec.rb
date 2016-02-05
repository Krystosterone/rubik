require "rails_helper"

describe WeekdayTimeRange do
  it_behaves_like "WeekdayTimeRange"
  it_behaves_like "it has a coerced attr_accessor", :starts_at, WeekdayTime
  it_behaves_like "it has a coerced attr_accessor", :ends_at, WeekdayTime
end
