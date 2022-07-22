# frozen_string_literal: true

module ThorCommandExampleGroup
  extend ActiveSupport::Concern

  RSpec.configure do |config|
    config.include self, type: :thor_command
  end

  included do
    subject(:thor_command) do
      ->(**args) { command_instance.invoke(method_name, [], **args) }
    end

    let(:command_instance) { Thor::Util.find_class_and_command_by_namespace(command_name, false).first.new }
    let(:command_path) { self.class.metadata[:file_path].sub(/^\.\/spec\//, "").sub(/_spec\.rb$/, "") }
    let(:command_name) { self.class.top_level_description.split(":").first }
    let(:method_name) { self.class.top_level_description.split(":").second }

    before { load(command_path) }
  end
end
