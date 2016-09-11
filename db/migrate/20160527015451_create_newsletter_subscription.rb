# frozen_string_literal: true
class CreateNewsletterSubscription < ActiveRecord::Migration[5.0]
  def change
    create_table :newsletter_subscriptions do |t|
      t.string :email
    end
  end
end
