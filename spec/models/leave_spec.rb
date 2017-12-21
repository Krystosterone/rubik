# frozen_string_literal: true

require "rails_helper"

describe Leave do
  it { is_expected.to have_attr_accessor(:_destroy) }

  it_behaves_like "WeekTimeRange"
end
