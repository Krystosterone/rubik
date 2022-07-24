# frozen_string_literal: true

class RemoveTagsFromTerms < ActiveRecord::Migration[6.1]
  def change
    remove_index :terms, column: %i[year name tags]
    remove_column :terms, :tags, :string
    add_index :terms, %i[year name], unique: true
  end
end
