# frozen_string_literal: true

require "rails_helper"

describe SimpleClosure do
  class SimpleClosureImpl < SimpleClosure
    def initialize(*); end

    def call; end
  end

  describe ".call" do
    let(:simple_closure_impl_instance) { instance_double(SimpleClosureImpl) }

    before do
      allow(SimpleClosureImpl).to receive(:new).and_return(simple_closure_impl_instance)
      allow(simple_closure_impl_instance).to receive(:call).and_return(:result)
    end

    it "instanciates the class with arguments and calls" do
      expect(SimpleClosureImpl.call(:one)).to eq(:result)
    end
  end
end
