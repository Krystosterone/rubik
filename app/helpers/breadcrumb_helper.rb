# frozen_string_literal: true
module BreadcrumbHelper
  def breadcrumb(&block)
    Breadcrumb.new(self, controller_name).render(&block)
  end
end
