SimpleNavigation::Configuration.run do |navigation|
  navigation.autogenerate_item_ids = false
  navigation.active_leaf_class = nil
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.dom_class = ''

    primary.item :home, 'Home', root_path
    primary.item :subjects, 'Subjects', '#'
    primary.item :collections, 'Collections', '#'
    primary.item :exhibitions, 'Exhibitions', '#'
    primary.item :map, 'Map', '#'
    primary.item :timeline, 'Timeline', '#'
    primary.item :applib, 'App Library', '#'
    primary.item :help, 'Help', '#'
  end

end
