# frozen_string_literal: true

require "rails_helper"

describe TermsHelper do
  let(:term) { instance_double(Term, name: "A name", year: "2015", tags: nil) }

  describe "#term_title" do
    context "with a term with no tags" do
      it "returns a concatenation of name year and tags" do
        expect(term_title(term)).to eq("A name 2015")
      end
    end

    context "with a term with tags" do
      before { allow(term).to receive(:tags).and_return("some tags") }

      it "returns a concatenation of name year and tags" do
        expect(term_title(term)).to eq("A name 2015 - some tags")
      end
    end
  end
end
