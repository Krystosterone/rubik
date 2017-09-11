# frozen_string_literal: true
module TermsHelper
  def term_iterator(terms)
    terms.map(&method(:term_decorator)).uniq
  end

  def term_title(term)
    [term.name, term.year, term_tags(term)].compact.join(" ")
  end

  private

  def term_decorator(term)
    OpenStruct.new(term.attributes.slice("name", "year"))
  end

  def term_tags(term)
    "- #{term.tags}" if term.tags.present?
  end
end
