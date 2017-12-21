# frozen_string_literal: true

class AddCombinedAtToAgendas < ActiveRecord::Migration
  def change
    add_column :agendas, :combined_at, :datetime
  end
end
