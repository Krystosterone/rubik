# frozen_string_literal: true
class GroupSerializer < Serializer
  class << self
    def dump_as_json(group)
      serialized_periods = group.periods.collect do |period|
        [period.type, period.starts_at.to_i, period.ends_at.to_i]
      end

      [group.number, serialized_periods]
    end

    def load_as_json(serialized_group)
      periods = serialized_group[1].collect do |serialized_period|
        Period.new(type: serialized_period[0],
                   starts_at: serialized_period[1],
                   ends_at: serialized_period[2])
      end

      Group.new(number: serialized_group[0], periods: periods)
    end
  end
end
