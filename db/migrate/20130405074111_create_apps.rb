class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :title
      t.string :author
      t.text   :description
      t.string :home_page_url
      t.string :icon
      t.string :screenshot

      t.timestamps
    end
  end
end
