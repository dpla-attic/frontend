class ChangeFiltersTypeInSavedSearches < ActiveRecord::Migration
  def up
  	change_column :saved_searches, :filters, :text
  end

  def down
  	change_column :saved_searches, :filters, :string
  end
end
