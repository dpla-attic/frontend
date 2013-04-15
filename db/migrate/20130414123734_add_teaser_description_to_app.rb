class AddTeaserDescriptionToApp < ActiveRecord::Migration
  def change
    add_column :apps, :teaser_description, :text
  end
end
