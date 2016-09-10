module SerializedRecord::FormBuilderHelper
  include ActionView::Helpers::OutputSafetyHelper

  def nested_form(association)
    member = association.to_s.singularize

    safe_join([
      association_container(association, member),
      javascript_template(association, member),
    ])
  end

  def association_container(association, member)
    association_fields = fields_for(association) { |f| @template.render(member, f: f) }
    @template.content_tag :div, association_fields, data: { "nested-form" => association }
  end

  def create_button(association, value, options = {})
    button value, options.merge(data: { "nested-form-create" => association }, type: "button")
  end

  def destroy_button(value, options = {})
    input_field = hidden_field(:_destroy, value: "1", disabled: true, data: { "nested-form-destroy-input" => "" })
    button = button(value, options.merge(data: { "nested-form-destroy" => "" }, type: "button"))

    safe_join([
      input_field,
      button,
    ])
  end

  private

  def javascript_template(association, member)
    field_name = "#{association}_attributes"
    klass = member.classify.constantize

    template_fields = fields_for(field_name,
                                 klass.new,
                                 index: "{{index}}") { |f| @template.render(member, f: f) }
    @template.content_tag(:script,
                          template_fields,
                          data: { "nested-form-template" => association },
                          type: "text/html")
  end
end
