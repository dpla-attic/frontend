class AncillaryNavigationRenderer < SimpleNavigation::Renderer::List
  def render(item_container)
    config_selected_class = SimpleNavigation.config.selected_class
    # Set active only for /about/* pages
    SimpleNavigation.config.selected_class = 'active' if options[:level].present?

    list_content = item_container.items.inject([]) do |list, item|
      li_options = item.html_options.reject {|k, v| k == :link}
      item.html_options[:class] = 'asdhaksdh'
      li_content = tag_for(item)
      if include_sub_navigation?(item)
        li_content << '<a class="support attribute flyout-toggle"><span></span></a>'.html_safe
        li_content << render_sub_navigation_for(item)
      end
      list << content_tag(:li, li_content, li_options)
    end.join

    SimpleNavigation.config.selected_class = config_selected_class

    if skip_if_empty? && item_container.empty?
      ''
    else
      container_class = case item_container.level
      # Top level
      when 1
        ['nav-bar', 'ancillary', 'right']
      # Sub level
      when 2
        # There is menu on /about/* pages if options[:level] present    
        options[:level].present? ? ['nav-bar', 'vertical'] : 'flyout'
      end          

      container_options = {:id => item_container.dom_id, :class => container_class}
      content_tag((options[:ordered] ? :ol : :ul), list_content, container_options) 
    end

  end
end
