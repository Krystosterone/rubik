# frozen_string_literal: true

require "rails_helper"

describe Contributor do
  it { is_expected.to have_attr_accessor(:user) }
  it { is_expected.to have_attr_accessor(:profile_url) }
  it { is_expected.to have_attr_accessor(:profile_image_url) }
end
