module SavedListsHelper
  def sort_icon_class
    case params[:sort].to_s.downcase
    when 'asc'  then 'icon-arrow-up'
    when 'desc' then 'icon-arrow-down'
    end
  end

  def sort_link_href
    case params[:sort].to_s.downcase
    when 'asc'  then url_for params.merge(sort: 'desc')
    else url_for params.merge(sort: 'asc')
    end
  end
end