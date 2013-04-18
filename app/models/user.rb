class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :is_admin

  has_many :saved_searches
  has_many :saved_lists
  has_many :saved_items, through: :saved_item_positions
  has_many :saved_item_positions

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  def active_for_authentication?
    true
  end
end
