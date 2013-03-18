require_dependency 'dpla/items'

class List
  attr_reader :term, :filters, :args, :facets

  # - term is search query
  # - filters is hash with refines
  #    {subject: 'Ships', type: ['image', 'text']}
  #
  def initialize(term, filters)
    @term    = term
    @filters = filters.is_a?(Hash) ? filters : {}
  end

  # Returns search results
  def items(args = {})
    @args = args
    results
  end

  def result(args = {})
    items(args)
  end

  # name is field e.g. :subject, :type, :lang, :before, :after, etc.
  def filters(name = nil)
    if name.present?
      @filters[name.to_sym].present? ? @filters[name.to_sym] : []
    else
      @filters
    end
  end

  # subject facets
  def subjects
    results.facets.subject
  end

  # languages facets
  def languages
    results.facets.language
  end

  # types facets
  def types
    results.facets.type
  end

  def locations
    results.facets.location
  end

  def count
    results.count
  end

  private

    def results
      @facets = %w(subject language type location)
      conditions = { q: @term, facets: @facets }.merge(@filters).merge(@args)
      @result || @result = DPLA::Items.by_conditions(conditions)
    end

end