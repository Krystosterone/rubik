# frozen_string_literal: true
module BreadcrumbHelper
  def breadcrumb(&block)
    Breadcrumb.new(self).render(&block)
  end
end
