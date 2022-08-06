# frozen_string_literal: true

class Breadcrumb::Crumb
  extend ActiveModel::Callbacks

  define_model_callbacks :initialize, only: :after

  include ActiveModel::Model
  include Defaults

  attr_accessor :additional_current_condition, :controller_name, :key, :path, :view_context, :visible

  after_initialize :set_current_proc
  default :additional_current_condition, proc { true }
  default :visible, proc { true }

  def initialize(*)
    run_callbacks(:initialize) { super }
  end

  %w[additional_current_condition path].each do |attribute|
    define_method(attribute) do
      view_context.instance_eval(&instance_variable_get("@#{attribute}"))
    end
  end

  %w[current visible].each do |attribute|
    define_method("#{attribute}?") do
      view_context.instance_eval(&instance_variable_get("@#{attribute}"))
    end
  end

  private

  def set_current_proc
    crumb = self
    @current = proc { crumb.controller_name.to_s.casecmp(controller_name).zero? && crumb.additional_current_condition }
  end
end
