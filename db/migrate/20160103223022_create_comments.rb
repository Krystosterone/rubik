class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_email
      t.text :body
    end
  end
end
