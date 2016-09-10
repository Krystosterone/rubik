require "rails_helper"

describe TermDecorator do
  describe "#title" do
    let(:term) { double(Term, name: "A name", year: "2015", tags: nil) }
    subject { described_class.new(term) }

    context "with a term with no tags" do
      it "returns a concatenation of name year and tags" do
        expect(subject.title).to eq("A name 2015")
      end
    end

    context "with a term with tags" do
      before { allow(term).to receive(:tags).and_return("some tags") }

      it "returns a concatenation of name year and tags" do
        expect(subject.title).to eq("A name 2015 - some tags")
      end
    end
  end
end
