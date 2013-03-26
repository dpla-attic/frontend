class SavedList < ActiveRecord::Base
  attr_accessible :title, :description, :private

  has_many :saved_items, dependent: :destroy
  belongs_to :user

  validates :title, :user, presence: true
end
