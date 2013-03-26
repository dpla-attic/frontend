class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :saved_searches
  has_many :saved_lists

  validates :name, presence: true

  def active_for_authentication?
    true
  end
end
