class SavedItemPosition < ActiveRecord::Base
  attr_accessible :saved_item, :saved_list, :user, :position
  attr_accessor :item

  belongs_to :saved_item
  belongs_to :saved_list
  belongs_to :user

  validates :saved_item, :user, presence: true

  def neighbors
    self.user.saved_item_positions
      .includes(:saved_list)
      .where(saved_item_id: saved_item)
  end
end
