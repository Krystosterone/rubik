# frozen_string_literal: true
module TermsHelper
  def term_title(term)
    [term.name, term.year, term_tags(term)].compact.join(" ")
  end

  private

  def term_tags(term)
    "- #{term.tags}" if term.tags.present?
  end
end
