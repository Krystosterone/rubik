# frozen_string_literal: true
class AddFilterGroupsToAgendas < ActiveRecord::Migration[5.0]
  def change
    add_column :agendas, :filter_groups, :boolean
  end
end
