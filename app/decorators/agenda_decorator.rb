# frozen_string_literal: true
class AgendaDecorator < Draper::Decorator
  delegate_all
  decorates_association :term

  delegate :name, to: :academic_degree, prefix: true
  delegate :title, to: :term, prefix: true
end
