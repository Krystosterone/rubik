# frozen_string_literal: true

class AddCombinedAtToAgendas < ActiveRecord::Migration[4.2]
  def change
    add_column :agendas, :combined_at, :datetime
  end
end
