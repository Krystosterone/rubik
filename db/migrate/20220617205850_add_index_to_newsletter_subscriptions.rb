# frozen_string_literal: true

class AddIndexToNewsletterSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_index :newsletter_subscriptions, :email, unique: true
  end
end
