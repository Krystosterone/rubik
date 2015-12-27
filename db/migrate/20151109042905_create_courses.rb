class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :code
      t.timestamps
    end

    add_index :courses, :code, unique: true
  end
end
