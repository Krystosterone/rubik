class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.integer :year
      t.string :name
      t.string :tags
      t.timestamps
    end

    add_index :terms, [:year, :name, :tags], unique: true
  end
end
