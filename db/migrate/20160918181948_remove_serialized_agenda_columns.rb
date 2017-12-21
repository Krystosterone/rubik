# frozen_string_literal: true

class RemoveSerializedAgendaColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :agendas, :courses, :text
    remove_column :agendas, :mandatory_course_ids, :text
  end
end
