# Remove once should-matchers supports rails 5

Shoulda::Matchers::RailsShim.class_eval do
  def self.serialized_attributes_for(model)
    model.columns.each_with_object({}) do |column, hash|
      type = model.type_for_attribute(column.name)
      hash[column.name.to_s] = type.coder if type.is_a?(::ActiveRecord::Type::Serialized)
    end
  end
end
