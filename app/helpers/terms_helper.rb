# frozen_string_literal: true

module TermsHelper
  def term_title(term)
    [term.name, term.year].compact.join(" ")
  end
end
