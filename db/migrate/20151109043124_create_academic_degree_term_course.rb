# frozen_string_literal: true

class CreateAcademicDegreeTermCourse < ActiveRecord::Migration
  def change
    create_table :academic_degree_term_courses do |t|
      t.references :academic_degree_term
      t.references :course
      t.text :groups
      t.timestamps
    end

    add_index :academic_degree_term_courses,
              %i[academic_degree_term_id course_id],
              unique: true,
              name: "academic_degree_terms_courses_index"
  end
end
