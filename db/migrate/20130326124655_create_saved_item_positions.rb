class CreateSavedItemPositions < ActiveRecord::Migration
  def change
    create_table :saved_item_positions do |t|
      t.integer :position
      t.references :user
      t.references :saved_item
      t.references :saved_list
      t.timestamps
    end
  end
end
