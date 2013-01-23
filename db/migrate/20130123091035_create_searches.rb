class CreateSearches < ActiveRecord::Migration
  def change
    create_table(:searches) do |t|
      t.text :params
    end
  end
end
