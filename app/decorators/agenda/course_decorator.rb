# frozen_string_literal: true
class Agenda::CourseDecorator < Draper::Decorator
  delegate_all
  decorates_association :groups
end
