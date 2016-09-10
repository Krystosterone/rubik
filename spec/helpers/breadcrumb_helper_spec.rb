require "rails_helper"

describe BreadcrumbHelper do
  describe "#breadcrumb" do
    let(:controller_name) { "some_controller_name" }
    let(:breadcrumb_instance) { double(Breadcrumb) }
    before do
      expect(breadcrumb_instance).to receive(:render) { |&b| b.call }
      expect(Breadcrumb).to receive(:new).with(self, "some_controller_name").and_return(breadcrumb_instance)
    end

    it "outputs breadcrumbs" do
      expect { |b| breadcrumb(&b) }.to yield_control
    end
  end
end
