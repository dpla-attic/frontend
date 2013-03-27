class SavedItem < ActiveRecord::Base
  attr_accessible :item_id, :saved_list_id

  belongs_to :saved_list
  belongs_to :user

  validates :item_id, :saved_list, :user, presence: true
end
