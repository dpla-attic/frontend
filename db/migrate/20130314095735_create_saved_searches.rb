class CreateSavedSearches < ActiveRecord::Migration
  def change
    create_table :saved_searches do |t|
      t.string :term
      t.string :filters
      t.integer :count
      t.references :user

      t.timestamps
    end
  end
end
