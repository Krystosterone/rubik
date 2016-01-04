class AddEnabledToTerms < ActiveRecord::Migration
  def change
    add_column :terms, :enabled_at, :datetime
  end
end
