require "rails_helper"

describe EtsPdf::Parser::ParsedLine do
  subject { described_class.new("some line") }

  its(:line) { is_expected.to eq("some line") }

  described_class::LINE_TYPES.each do |type, klass|
    describe "##{type}" do
      let(:mock_line) { double(klass) }
      before { allow(klass).to receive(:new).with("some line").and_return(mock_line) }

      it "returns the decorated line" do
        expect(subject.public_send(type)).to eq(mock_line)
      end
    end
  end

  describe "#type?" do
    context "when an unhandled type is passed" do
      it "returns false" do
        expect(subject.type?(:unhandled)).to eq(false)
      end
    end

    described_class::LINE_TYPES.each do |type, klass|
      context "when :#{type} is passed" do
        let(:mock_line) { double(klass) }
        before { allow(klass).to receive(:new).with("some line").and_return(mock_line) }

        it "delegates .parsed? to the #{type} line" do
          allow(mock_line).to receive(:parsed?).and_return(false)
          expect(subject.type?(type)).to eq(false)

          allow(mock_line).to receive(:parsed?).and_return(true)
          expect(subject.type?(type)).to eq(true)
        end
      end
    end
  end

  describe "#parsed?" do
    context "when none of the lines have been parsed" do
      before do
        described_class::LINE_TYPES.values.each do |klass|
          mock_line(klass, parsed: false)
        end
      end

      its(:parsed?) { is_expected.to eq(false) }
    end

    described_class::LINE_TYPES.each do |type, klass|
      context "when the #{type} has been parsed" do
        before do
          described_class::LINE_TYPES.values.each do |unparsed_klass|
            mock_line(unparsed_klass, parsed: false)
          end
          mock_line(klass, parsed: true)
        end

        its(:parsed?) { is_expected.to eq(true) }
      end
    end
  end

  def mock_line(klass, parsed:)
    mock_line = double(klass)

    allow(klass).to receive(:new).with("some line").and_return(mock_line)
    allow(mock_line).to receive(:parsed?).and_return(parsed)
  end
end
