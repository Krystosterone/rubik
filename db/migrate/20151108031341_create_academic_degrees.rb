# frozen_string_literal: true

class CreateAcademicDegrees < ActiveRecord::Migration
  def change
    create_table :academic_degrees do |t|
      t.string :code
      t.string :name
      t.timestamps
    end

    add_index :academic_degrees, :code, unique: true
  end
end
