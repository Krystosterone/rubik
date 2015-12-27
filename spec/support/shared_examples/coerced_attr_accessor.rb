shared_examples 'it has a coerced attr_accessor' do |attribute, klass|
  describe "##{attribute} attr_accessor" do
    context "when passing in a #{klass.name}" do
      before { subject.public_send "#{attribute}=", klass.new(50) }
      its(attribute) { is_expected.to eq(klass.new(50)) }
    end

    context 'when passing in an integer' do
      before { subject.public_send "#{attribute}=", 100 }
      its(attribute) { is_expected.to eq(klass.new(100)) }
    end
  end
end
