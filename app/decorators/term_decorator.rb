class TermDecorator < Draper::Decorator
  delegate_all

  def title
    [name, year, title_tags].compact.join(' ')
  end

  private

  def title_tags
    "- #{tags}" if tags.present?
  end
end
