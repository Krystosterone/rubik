# frozen_string_literal: true

module BreadcrumbHelper
  def breadcrumb(agenda, step)
    Breadcrumb.new(agenda, step, self)
  end
end
