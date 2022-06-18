# frozen_string_literal: true

shared_examples "it has a coerced attr_accessor" do |attribute, klass|
  describe "##{attribute} attr_accessor" do
    subject(:coerced_attribute_subject) { described_class.new }

    context "when passing in a #{klass.name}" do
      before { coerced_attribute_subject.public_send "#{attribute}=", klass.new(50) }

      its(attribute) { is_expected.to eq(klass.new(50)) }
    end

    context "when passing in an integer" do
      before { coerced_attribute_subject.public_send "#{attribute}=", 100 }

      its(attribute) { is_expected.to eq(klass.new(100)) }
    end
  end
end
