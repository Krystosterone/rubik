# frozen_string_literal: true

class CreateTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :terms do |t|
      t.integer :year
      t.string :name
      t.string :tags
      t.timestamps
    end

    add_index :terms, %i[year name tags], unique: true
  end
end
