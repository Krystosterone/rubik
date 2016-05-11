class TermsController < ApplicationController
  decorates_assigned :terms

  def index
    @terms = Term.includes(:academic_degree_terms, academic_degree_terms: :academic_degree).enabled.all
  end
end
