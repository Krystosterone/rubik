# frozen_string_literal: true

# rubocop:disable Rails/CreateTableWithTimestamps
class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.string :user_email
      t.text :body
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
