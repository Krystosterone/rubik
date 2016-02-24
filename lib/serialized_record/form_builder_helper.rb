module SerializedRecord::FormBuilderHelper
  def nested_form(association)
    member = association.to_s.singularize
    klass = member.classify.constantize
    field_name = "#{association}_attributes"

    association_fields = fields_for(association) { |f| @template.render(member, f: f) }
    container = @template.content_tag :div, association_fields, data: { :"nested-form" => association }

    template_fields = fields_for(field_name,
                                 klass.new,
                                 index: "{{index}}") { |f| @template.render(member, f: f) }
    javascript_template = @template.content_tag(:script,
                                                template_fields,
                                                data: { :"nested-form-template" => association },
                                                type: "text/html")




    [
      container,
      javascript_template,
    ].join.html_safe
  end

  def create_button(association, value, options = {})
    button value, options.merge(data: { :"nested-form-create" => association }, type: "button")
  end

  def destroy_button(value, options = {})
    input_field = hidden_field(:_destroy, value: "1", disabled: true, data: { :"nested-form-destroy-input" => "" })
    button = button(value, options.merge(data: { :"nested-form-destroy" => "" }, type: "button"))

    [
      input_field,
      button,
    ].join.html_safe
  end
end
