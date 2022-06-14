# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.string :code
      t.timestamps
    end

    add_index :courses, :code, unique: true
  end
end
