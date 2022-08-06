# frozen_string_literal: true

class Breadcrumb
  CRUMB_ATTRIBUTES = [
    {
      controller_name: :terms,
      key: "terms",
      path: ->(_) { root_path },
    },
    {
      additional_current_condition: ->(step) { step == AgendaCreationProcess::STEP_COURSE_SELECTION },
      controller_name: :agendas,
      key: "agendas.course_selection",
      path: ->(agenda) { edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_COURSE_SELECTION) },
    },
    {
      additional_current_condition: ->(step) { step == AgendaCreationProcess::STEP_GROUP_SELECTION },
      controller_name: :agendas,
      key: "agendas.group_selection",
      path: ->(agenda) { edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_GROUP_SELECTION) },
      visible: ->(agenda) { @agenda.filter_groups? },
    },
    {
      controller_name: :schedules,
      key: "schedules",
    },
  ].freeze

  def initialize(agenda, step, view_context)
    @agenda = agenda
    @step = step
    @view_context = view_context
  end

  def render(&block)
    instance_eval(&block)
  end

  def current_name
    breadcrumb_t(current_crumb.key)
  end

  def links
    current_crumbs.select(&:visible?).collect(&method(:breadcrumb_link))
  end

  private

  def current_crumb
    crumbs[current_index]
  end

  def current_index
    crumbs.index(&:current?)
  end

  def current_crumbs
    crumbs[0..[current_index - 1, 0].max]
  end

  def crumbs
    @crumbs ||= CRUMB_ATTRIBUTES
      .each_with_object([]) do |attributes, memo|
        attributes[:additional_current_condition]
        memo << attributes
      end
      .map { |attributes| Crumb.new(attributes.merge(view_context: @view_context)) }
  end

  def breadcrumb_t(key)
    t ".#{key}"
  end

  def breadcrumb_link(crumb)
    link_to breadcrumb_t(crumb.key), crumb.path
  end

  def respond_to_missing?(method_name, *_arguments, &_block)
    @view_context.respond_to?(method_name)
  end

  def method_missing(method_name, *args, &block)
    respond_to_missing?(method_name) ? @view_context.send(method_name, *args, &block) : super
  end
end
