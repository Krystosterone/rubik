# frozen_string_literal: true

class DropNewsletterSubscriptions < ActiveRecord::Migration[5.2]
  def change
    drop_table :newsletter_subscriptions do |t|
      t.string :email, index: { unique: true }
    end
  end
end
