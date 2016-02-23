class AddIndexToSchedulesAgendaId < ActiveRecord::Migration[5.0]
  def change
    add_index :schedules, :agenda_id
  end
end
