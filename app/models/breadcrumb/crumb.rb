# frozen_string_literal: true
class Breadcrumb::Crumb
  include ActiveModel::Model

  attr_accessor :additional_current_condition, :controller_name, :key, :path, :view_context, :visible

  def initialize(*)
    super
    set_defaults
    set_current_proc
  end

  %w(additional_current_condition path).each do |attribute|
    define_method(attribute) do
      view_context.instance_eval(&instance_variable_get("@#{attribute}"))
    end
  end

  %w(current visible).each do |attribute|
    define_method("#{attribute}?") do
      view_context.instance_eval(&instance_variable_get("@#{attribute}"))
    end
  end

  private

  def set_defaults
    @additional_current_condition ||= proc { true }
    @controller_name ||= key.split(".").first
    @key ||= controller_name
    @visible ||= proc { true }
  end

  def set_current_proc
    crumb = self
    @current = proc { crumb.controller_name.to_s.casecmp(controller_name).zero? && crumb.additional_current_condition }
  end
end
