class SavedItem < ActiveRecord::Base
  attr_accessible :item_id

  belongs_to :saved_list
  belongs_to :user

  validates :item_id, :user, presence: true
end
