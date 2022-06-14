# frozen_string_literal: true

class CreateSchedules < ActiveRecord::Migration[4.2]
  def change
    create_table :schedules do |t|
      t.references :agenda
      t.text :course_groups
      t.timestamps
    end
  end
end
