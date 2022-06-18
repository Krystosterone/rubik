# frozen_string_literal: true

require "rails_helper"

describe FaqsController do
  describe "#show" do
    before { get :show }

    it { is_expected.to render_template(:show) }
  end
end
