# frozen_string_literal: true

class AddEnabledToTerms < ActiveRecord::Migration[4.2]
  def change
    add_column :terms, :enabled_at, :datetime
  end
end
