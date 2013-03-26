class CreateSavedLists < ActiveRecord::Migration
  def change
    create_table :saved_lists do |t|
      t.string :title
      t.text :description
      t.boolean :private
      t.references :user

      t.timestamps
    end
  end
end
