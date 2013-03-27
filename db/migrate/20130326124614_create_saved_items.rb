class CreateSavedItems < ActiveRecord::Migration
  def change
    create_table :saved_items do |t|
      t.string :item_id
      t.timestamps
    end
  end
end
