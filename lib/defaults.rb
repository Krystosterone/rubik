# frozen_string_literal: true

module Defaults
  extend ActiveSupport::Concern

  included do
    after_initialize :set_default_values, unless: :persisted?
  end

  def set_default_values
    self.class.runtime_defaults.each do |attribute, block|
      public_send("#{attribute}=", instance_eval(&block)) if public_send(attribute).nil?
    end

    self.class.defaults.each do |attribute, value|
      public_send("#{attribute}=", value) if public_send(attribute).nil?
    end
  end

  class_methods do
    def defaults
      @defaults ||= {}
    end

    def runtime_defaults
      @runtime_defaults ||= {}
    end

    def default(attribute, value = nil, &block)
      if block.nil?
        defaults[attribute] = value
      else
        runtime_defaults[attribute] = block
      end
    end
  end
end
