# frozen_string_literal: true
class Group
  include ActiveModel::Model
  include Draper::Decoratable
  include SerializedRecord::FindOrInitializeFor

  serialized_find_or_initialize_for :periods

  def initialize(attributes = {})
    super
    @periods ||= []
  end
  attr_accessor :number, :periods
  delegate :empty?, to: :periods

  def overlaps?(other)
    periods.any? do |period|
      other.periods.any? { |other_period| period.overlaps?(other_period) }
    end
  end

  def ==(other)
    number == other.number && periods == other.periods
  end
end
