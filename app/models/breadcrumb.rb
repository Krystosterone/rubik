# frozen_string_literal: true
class Breadcrumb
  CRUMBS = [
    {
      controller_name: :terms,
      path: proc { root_path },
    },
    {
      additional_current_condition: proc { step == AgendaCreationProcess::STEP_COURSE_SELECTION },
      key: "agendas.course_selection",
      path: proc { edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_COURSE_SELECTION) },
    },
    {
      additional_current_condition: proc { step == AgendaCreationProcess::STEP_GROUP_SELECTION },
      key: "agendas.group_selection",
      path: proc { edit_agenda_path(agenda, step: AgendaCreationProcess::STEP_GROUP_SELECTION) },
      visible: proc { agenda.filter_groups? }
    },
    { controller_name: :schedules },
  ].freeze

  def initialize(view_context)
    @view_context = view_context
  end

  def render(&block)
    instance_eval(&block)
  end

  def current_name
    breadcrumb_t(current_crumb.key)
  end

  def links(&block)
    current_crumbs.select(&:visible?).collect(&method(:breadcrumb_link)).each(&block)
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
    @crumbs ||= CRUMBS.map { |attributes| Crumb.new(attributes.merge(view_context: @view_context)) }
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
