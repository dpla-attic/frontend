class State < ActiveRecord::Base
  attr_accessible :abbr, :name, :lat, :lng

  def self.geocode(name)
    if state = find_by_name(name)
      [state.lat, state.lng]
    end
  end
end
