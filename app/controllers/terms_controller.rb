class TermsController < ApplicationController
  decorates_assigned :terms

  def index
    @terms = Term.ordered
  end
end
