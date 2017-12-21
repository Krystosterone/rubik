# frozen_string_literal: true

class CreateAgendaCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :agenda_courses do |t|
      t.references :academic_degree_term_course
      t.references :agenda
      t.boolean :mandatory
      t.timestamps
    end

    add_index :agenda_courses, %i[academic_degree_term_course_id agenda_id], unique: true, name: "agenda_courses_index"
  end
end
