# frozen_string_literal: true
class LeavesSerializer < Serializer
  class << self
    def dump_as_json(leaves)
      leaves.collect { |leave| [leave.starts_at.to_i, leave.ends_at.to_i] }
    end

    def load_as_json(serialized_leaves)
      serialized_leaves.collect do |serialized_leave|
        Leave.new(starts_at: serialized_leave[0], ends_at: serialized_leave[1])
      end
    end
  end
end
