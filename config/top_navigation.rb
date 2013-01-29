SimpleNavigation::Configuration.run do |navigation|
  navigation.autogenerate_item_ids = false
  navigation.active_leaf_class = nil
  navigation.selected_class = nil

  navigation.items do |primary|
    primary.item :about, 'About', about_root_path do |sub_nav|
      sub_nav.item :overview, 'Overview', about_overview_path
      sub_nav.item :leadership, 'Leadership', about_leadership_path
      sub_nav.item :workstreams, 'Workstreams', about_workstreams_path
      sub_nav.item :for_developers, 'For Developers', about_for_developers_path
      sub_nav.item :get_involved, 'Get Involved', about_get_involved_path
    end

    primary.item :news, 'News', '#'
    primary.item :contacts, 'Contact', '#'
    primary.item :sign_in, 'Login', new_user_session_path, class: 'bg'
    primary.item :sign_up, 'Sign Up', new_user_registration_path, class: 'bg last'
    primary.item :sign_up, 'Sign Out', new_user_registration_path, class: 'bg last', if: -> { current_user.present? }
  end

end
