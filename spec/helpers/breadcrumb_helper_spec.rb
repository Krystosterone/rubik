# frozen_string_literal: true
require "rails_helper"

describe BreadcrumbHelper do
  describe "#breadcrumb" do
    let(:controller_name) { "some_controller_name" }
    let(:breadcrumb_instance) { instance_double(Breadcrumb) }
    before do
      allow(breadcrumb_instance).to receive(:render) { |&b| b.call }
      allow(Breadcrumb).to receive(:new).with(self, "some_controller_name").and_return(breadcrumb_instance)
    end

    it "outputs breadcrumbs" do
      expect { |b| breadcrumb(&b) }.to yield_control
    end
  end
end
