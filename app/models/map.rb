require_dependency 'dpla/items'

class Map < Search

  def geocoded_states
    [].tap do |result|
      states.each do |state, count|
        coord = State.geocode state
        result << {name: state, count: count, lat: coord.first, lng: coord.last} if coord
      end
    end
  end

end