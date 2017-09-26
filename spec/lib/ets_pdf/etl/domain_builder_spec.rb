# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Etl::DomainBuilder do
  describe ".call" do
    let(:units) { double }

    it "calls the term builder" do
      allow(EtsPdf::Etl::TermBuilder).to receive(:call)

      described_class.call(units)

      expect(EtsPdf::Etl::TermBuilder).to have_received(:call).with(units)
    end
  end
end
