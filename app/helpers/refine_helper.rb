module RefineHelper
  def refine_path(area, value, options = {})
    existing_refine = params[area] || []
    existing_refine = Array(existing_refine)
    refine_params = options[:remove] ? existing_refine - [value] : existing_refine + [value]
    params.deep_merge(area => refine_params.uniq)
  end

  def subject_facets
    @search.subjects.reject { |v| subject_refines.include? v }.to_a
  end

  def subject_refines
    @search.filters :subject
  end

  def type_facets
    @search.types.reject { |v| type_refines.include? v }.to_a
  end

  def type_refines
    @search.filters :type
  end

  def language_facets
    @search.languages.reject { |v| language_refines.include? v }.to_a
  end

  def language_refines
    @search.filters :language
  end

  def after_refine
    @search.filters(:after)
  end

  def before_refine
    @search.filters(:before)
  end
end