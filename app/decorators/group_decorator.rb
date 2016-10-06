# frozen_string_literal: true
class GroupDecorator < Draper::Decorator
  delegate_all
  decorates_association :periods
end
