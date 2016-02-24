class CreateDonations < ActiveRecord::Migration[5.0]
  def change
    create_table :donations do |t|
      t.string :donator_email
      t.decimal :amount
      t.text :message
    end
  end
end
