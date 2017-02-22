# frozen_string_literal: true
class AgendaDecorator < Draper::Decorator
  delegate_all
  decorates_association :courses, with: Agenda::CourseDecorator
end
