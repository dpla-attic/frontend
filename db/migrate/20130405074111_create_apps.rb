class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :home_page

      t.timestamps
    end
  end
end
