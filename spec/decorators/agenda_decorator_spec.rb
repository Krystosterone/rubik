# frozen_string_literal: true
require "rails_helper"

describe AgendaDecorator do
  subject(:decorator) { described_class.new(agenda) }
  let(:agenda) { instance_double(Agenda, courses: []) }

  describe "#courses" do
    specify { expect(decorator.courses).to be_decorated }
  end
end
