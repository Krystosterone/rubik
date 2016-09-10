class Breadcrumb
  ORDER = %w(terms agendas schedules).freeze

  def initialize(view_context, current_handle)
    @view_context = view_context
    @current_handle = current_handle
  end

  def render(&block)
    instance_eval(&block)
  end

  def current_name
    breadcrumb_t(@current_handle)
  end

  def links
    link_names.collect { |name| yield breadcrumb_link(name) }
  end

  private

  def link_names
    ending = current_index - 1
    ending < 0 ? [] : ORDER[0..ending]
  end

  def current_index
    ORDER.index(@current_handle)
  end

  def breadcrumb_link(name)
    link_to breadcrumb_t(name), breadcrumb_path(name)
  end

  def breadcrumb_path(name)
    case name
    when "terms"
      root_path
    when "agendas"
      new_academic_degree_term_agenda_path(agenda.academic_degree_term)
    end
  end

  def breadcrumb_t(name)
    t ".#{name}"
  end

  def respond_to_missing?(method_name, *_arguments, &_block)
    @view_context.respond_to?(method_name)
  end

  def method_missing(method_name, *args, &block)
    respond_to_missing?(method_name) ? @view_context.send(method_name, *args, &block) : super
  end
end
