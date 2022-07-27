# frozen_string_literal: true

require "rails_helper"

describe FaqsHelper do
  describe "#avatar_url" do
    let(:contributor) { instance_double(Contributor) }

    context "with no existing query params" do
      before { allow(contributor).to receive(:profile_image_url).and_return("url.com") }

      it "returns the url with appended query param" do
        expect(helper.avatar_url(contributor, size: 20)).to eq("url.com?s=20")
      end
    end

    context "with existing query params" do
      before { allow(contributor).to receive(:profile_image_url).and_return("url.com?v=4") }

      it "returns the url with appended query param" do
        expect(helper.avatar_url(contributor, size: 20)).to eq("url.com?v=4&s=20")
      end
    end
  end
end
