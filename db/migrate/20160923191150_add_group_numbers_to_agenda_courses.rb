# frozen_string_literal: true

class AddGroupNumbersToAgendaCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :agenda_courses, :group_numbers, :text
  end
end
