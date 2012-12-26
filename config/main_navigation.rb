# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'nav-bar'

    primary.item :home,        'Home', root_path
    primary.item :subjects,    'Subjects', '#'
    primary.item :collections, 'Collections', '#'
    primary.item :exhibitions, 'Exhibitions', '#'
    primary.item :map,         'Map', '#'
    primary.item :timeline,    'Timeline', '#'
    primary.item :applib,      'App Library', '#'
    primary.item :help,        'Help', '#', class: 'right'
  end

end
