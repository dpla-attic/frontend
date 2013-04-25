require_dependency 'dpla/items'

class Timeline < Search

  def fields
    %w(
      id sourceResource.title isShownAt object
      sourceResource.type sourceResource.creator
      sourceResource.description
    )
  end

  def api_search_path
    conditions = DPLA::Conditions.new({ q: @term }.merge(@filters).merge(fields: fields))
    "#{api_base_path}/items?#{conditions}#{api_key}"
  end

  def api_item_path
    "#{api_base_path}/items?id=%&fields=#{fields.join(',')}&#{api_key}"
  end

  def years
    result.facets.year
  end

  def conditions
    facets = %w(date)
    conditions = { q: @term, facets: facets }.merge(@filters).merge(page_size: 0, facet_size: 2000)
  end

end

  # def items_by_year
  #   @search = Timeline.new permitted_params.term, permitted_params.filters
  #   page = params[:page].to_i if params[:page]
  #   @year = params[:year] ? params[:year].to_i : Time.now.year
  #   @items = @search.items(@year, page || 0)
  #   render partial: "timeline/items", locals: { items: @items }, layout: false
  # end