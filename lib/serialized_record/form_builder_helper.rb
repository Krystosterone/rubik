module SerializedRecord::FormBuilderHelper
  def create_button(method, value, options = {})
    association_size = object.public_send(method).size
    default_options = {
      name: "#{object_name}[#{method}_attributes][#{association_size}][_create]",
      value: 1,
      formaction: "#{self.options[:url]}/##{method}"
    }

    button value, options.reverse_merge(default_options)
  end

  def destroy_button(value, options = {})
    parent_url = self.options[:parent_builder].options[:url]
    anchor_name = object.class.name.underscore.pluralize

    default_options = {
      name: "#{object_name}[_destroy]",
      value: 1,
      formaction: "#{parent_url}/##{anchor_name}",
    }

    button value, options.reverse_merge(default_options)
  end
end
