# frozen_string_literal: true
require "rails_helper"

describe WeekTimeRange do
  it_behaves_like "WeekTimeRange"
  it_behaves_like "it has a coerced attr_accessor", :starts_at, WeekTime
  it_behaves_like "it has a coerced attr_accessor", :ends_at, WeekTime
end
