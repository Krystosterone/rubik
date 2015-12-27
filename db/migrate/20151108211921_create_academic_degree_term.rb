class CreateAcademicDegreeTerm < ActiveRecord::Migration
  def change
    create_table :academic_degree_terms do |t|
      t.references :academic_degree
      t.references :term
      t.timestamps
    end

    add_index :academic_degree_terms, [:academic_degree_id, :term_id], unique: true
  end
end
