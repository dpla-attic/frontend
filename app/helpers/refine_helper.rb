module RefineHelper
  def refine_path(area, value, options = {})
    existing_refine = params[area] || []
    existing_refine = Array(existing_refine)
    refine_params = options.delete(:remove).present? ? existing_refine - [value] : existing_refine + [value]
    params.merge(options).deep_merge(area => refine_params.uniq, page: nil)
  end

  def subject_facets
    @search.subjects ? @search.subjects.reject { |v| subject_refines.include? v }.to_a : []
  end

  def subject_refines
    Array @search.filters :subject
  end

  def type_facets
    @search.types ? @search.types.reject { |v| type_refines.include? v }.to_a : []
  end

  def type_refines
    Array @search.filters :type
  end

  def provider_facets
    @search.providers ? @search.providers.reject { |v| provider_refines.include? v }.to_a : []
  end

  def provider_refines
    Array @search.filters :provider
  end

  def language_facets
    @search.languages ? @search.languages.reject { |v| language_refines.include? v }.to_a : []
  end

  def language_refines
    Array @search.filters :language
  end

  def after_refine
    @search.filters(:after)
  end

  def before_refine
    @search.filters(:before)
  end

  def country_facets
    @search.countries ? @search.countries.reject { |v| country_refines.include? v }.to_a : []
  end

  def country_refines
    Array @search.filters :country
  end

  def state_facets
    @search.states ? @search.states.reject { |v| state_refines.include? v }.to_a : []
  end

  def state_refines
    Array @search.filters :state
  end

  def place_facets
    @search.places ? @search.places.reject { |v| place_refines.include? v }.to_a : []
  end

  def place_refines
    Array @search.filters :place
  end
end