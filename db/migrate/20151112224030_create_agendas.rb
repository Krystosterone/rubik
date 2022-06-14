# frozen_string_literal: true

class CreateAgendas < ActiveRecord::Migration[4.2]
  def change
    create_table :agendas do |t|
      t.references :academic_degree_term
      t.string :token
      t.integer :courses_per_schedule
      t.text :courses
      t.text :leaves
      t.timestamps
    end

    add_index :agendas, :token
  end
end
