class AddPromoFlagToApp < ActiveRecord::Migration
  def change
    add_column :apps, :is_promo, :boolean
  end
end
