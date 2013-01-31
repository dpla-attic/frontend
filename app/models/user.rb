class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, presence: true

  def active_for_authentication?
    true
    #confirmed? || confirmation_period_valid?
  end
end
