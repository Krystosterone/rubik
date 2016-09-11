# frozen_string_literal: true
class AddProcessingToAgendas < ActiveRecord::Migration[5.0]
  def change
    add_column :agendas, :processing, :boolean
  end
end
