# frozen_string_literal: true

require "rails_helper"

describe TermsHelper do
  let(:term) { instance_double(Term, name: "A name", year: "2015") }

  it "returns a concatenation of name and year" do
    expect(term_title(term)).to eq("A name 2015")
  end
end
