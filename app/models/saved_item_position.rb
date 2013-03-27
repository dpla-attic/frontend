class SavedItemPosition < ActiveRecord::Base
  attr_accessible :saved_item, :saved_list, :user, :position

  belongs_to :saved_item
  belongs_to :saved_list
  belongs_to :user

  validates :saved_item, :user, presence: true
end
