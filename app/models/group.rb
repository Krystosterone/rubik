class Group
  include ActiveModel::Model
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
    periods == other.periods
  end
end
