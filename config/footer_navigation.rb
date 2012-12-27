# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|
    primary.dom_class = 'link-list left'

    primary.item :home, 'Home', root_path
    primary.item :home, 'Home', '#'
    primary.item :subjects, 'Subjects', '#'
    primary.item :collections, 'Collections', '#'
    primary.item :exhibitions, 'Exhibitions', '#'
    primary.item :map, 'Map', '#'
    primary.item :timeline, 'Timeline', '#'
    primary.item :app_library, 'App Library', '#'
    primary.item :help, 'Help', '#'
    primary.item :about, 'About', '#'
    primary.item :news, 'News', '#'
    primary.item :contact, 'Contact', '#'
    primary.item :accessibility, 'Accessibility', '#'
  end

end
