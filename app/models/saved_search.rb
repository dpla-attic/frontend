class SavedSearch < ActiveRecord::Base
  attr_accessible :term, :filters, :term
  serialize :filters, Hash

  belongs_to :user

  default_scope order('updated_at DESC')

  def method_name
  	
  end
end
