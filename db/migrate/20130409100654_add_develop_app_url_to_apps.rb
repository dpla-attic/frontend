class AddDevelopAppUrlToApps < ActiveRecord::Migration
  def change
    add_column :apps, :develop_app_url, :string
  end
end
