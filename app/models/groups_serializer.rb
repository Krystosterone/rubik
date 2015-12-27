class GroupsSerializer < Serializer
  class << self
    def dump_as_json(groups)
      groups.collect { |group| GroupSerializer.dump_as_json(group) }
    end

    def load_as_json(serialized_groups)
      serialized_groups.collect { |serialized_group| GroupSerializer.load_as_json(serialized_group) }
    end
  end
end
