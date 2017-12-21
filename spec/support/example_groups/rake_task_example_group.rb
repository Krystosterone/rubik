# frozen_string_literal: true

module RakeTaskExampleGroup
  extend ActiveSupport::Concern

  RSpec.configure do |config|
    config.include self,
                   type: :rake_task,
                   file_path: %r{spec/lib/tasks}
  end

  included do
    subject(:rake_task) { Rake::Task[task_name] }

    let(:task_name) { self.class.top_level_description }
  end
end
