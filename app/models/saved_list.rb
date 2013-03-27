class SavedList < ActiveRecord::Base
  attr_accessible :title, :description, :private

  has_many :saved_items, through: :saved_item_positions
  has_many :saved_item_positions, dependent: :destroy
  belongs_to :user

  validates :title, :user, presence: true
end
