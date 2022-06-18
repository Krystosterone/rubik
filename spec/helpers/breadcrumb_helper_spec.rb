# frozen_string_literal: true

require "rails_helper"

describe BreadcrumbHelper do
  describe "#breadcrumb" do
    let(:breadcrumb_instance) { instance_double(Breadcrumb) }

    before do
      allow(breadcrumb_instance).to receive(:render).and_yield
      allow(Breadcrumb).to receive(:new).with(self).and_return(breadcrumb_instance)
    end

    it "outputs breadcrumbs" do
      expect { |block| breadcrumb(&block) }.to yield_control
    end
  end
end
