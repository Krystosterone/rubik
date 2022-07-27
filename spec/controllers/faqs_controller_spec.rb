# frozen_string_literal: true

require "rails_helper"

describe FaqsController do
  render_views

  describe "#show" do
    before { get :show }

    it { is_expected.to render_template(:show) }

    it "assigns contributors" do
      expect(assigns(:contributors)).to eq(Rails.application.config.x.contributors)
    end

    it "contains contributors" do
      expect(response.body).to have_tag("a", with: { href: "profile.com", title: "potato" }) do
        with_tag "img", with: { alt: "potato", src: "image.com?s=60" }
      end
    end
  end
end
