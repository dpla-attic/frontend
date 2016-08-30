class Item
  extend ActiveModel::Naming

  def initialize(doc)
    doc = transform_dotted_keys doc
    @id                     = doc['id']
    @sourceResource         = doc['sourceResource'] || {}
    @object                 = doc['object']
    @isShownAt              = doc['isShownAt']
    @dataProvider           = doc['dataProvider']
    @intermediateProvider   = doc['intermediateProvider']
    @edmRights              = doc['rights']
    @hasView                = doc['hasView'] || {}
    @provider               = doc['provider']['name'] if doc['provider']
    @score                  = doc['score']
    @date                   = @sourceResource['date'] || {}
    if @sourceResource['spatial'].present? and not @sourceResource['spatial'].is_a? Array
      @sourceResource['spatial'] = [ @sourceResource['spatial'] ]
    end
  end

  def id
    @id
  end

  def publisher
    Array @sourceResource['publisher']
  end

  def description
    description = Array(@sourceResource['description']).compact.each do |x|
      if x !~ /[.,?!;:]$/
        x << "."
      end
    end
    description.join(" ")
  end

  def title
    Array(@sourceResource['title']).first
  end

  def titles(options = {})
    if options[:with_first]
      Array(@sourceResource['title'])
    else
      Array(@sourceResource['title'])[1..-1]
    end
  end

  # @return [Array<String>]
  # downcase first letter if rights statement is URI
  def rights
    Array.wrap(@sourceResource['rights']).map do |rights|
      if valid_http_uri?(rights)
        rights[0, 1].downcase + rights[1..-1]
      else
        rights
      end
    end
  end

  #returns and array of statements
  def standardized_rights_statement
    statement = [@edmRights]
    if @hasView.is_a? Array
      @hasView.each { |view| statement.push( view['edmRights'] ) }
    else
      statement.push @hasView['edmRights']
    end
    statement.compact
  end

  # returns an array of displayDate values
  def created_date
    dates = []
    if @date.is_a? Array
      @date.each do |d|
        dates.push d['displayDate'] rescue nil
      end
    else
      dates.push @date['displayDate'] rescue nil
    end
    dates.compact
    return nil if dates.empty?
    dates
  end

  def year
    if @date.is_a? Array
      year = @date.first['begin'].split('-').first rescue nil
    else
      year = @date['begin'].split('-').first rescue nil
    end
    return nil unless year =~ /\A[-]?[0-9]+\z/
    year
  end

  # returns array with names
  def location
    location = @sourceResource['spatial'].map do |loc|
      l = loc['name']
    end if @sourceResource['spatial'].present?
    Array location
  end

  def coordinates
    if @sourceResource['spatial'].present?
      @sourceResource['spatial'].map{ |l| l['coordinates'].split ',' rescue nil}.compact
    end
  end

  def creator
    Array(@sourceResource['creator']).join '; '
  end

  def subject
    @sourceResource['subject'].map{|l| l['name']} if @sourceResource['subject']
  end

  def type
    @sourceResource['type']
  end

  def url
    if @isShownAt.is_a? Array
      return @isShownAt[0]
    end
    @isShownAt
  end

  def format
    @sourceResource['format']
  end

  # @return [String, nil]  link to DPLA thumbnail HTTPS proxy service if it is a
  # valid HTTP uri; nil otherwise
  def preview_image
    object = Array.wrap(@object).first
    return object if valid_http_uri?(object)
    nil
  end

  def preview_image_ssl
    object = Array.wrap(@object).first
    return "//#{Settings.url.host}/thumb/#{@id}" if valid_http_uri?(object)    
    nil
  end

  def data_provider
    @dataProvider
  end

  def contributing_institution
    [@dataProvider, @intermediateProvider].compact
  end

  def provider
    @provider
  end

  def score
    @score
  end

  # @return [Array<String>]
  def language
    Array.wrap(@sourceResource['language']).map { |l| l['name'] }.compact
  end

  private

  def valid_http_uri?(uri)
    URI.parse(uri).kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end

  def transform_dotted_keys(doc)
    doc.keys
      .select { |k| k.index('.') }
      .select { |k| k =~ /^(sourceResource|object)/ }
      .each do |k|
        value = doc.delete k
        tokens = k.split '.'
        first_token = tokens.shift
        tokens.reverse.each { |t| value = {t => value} }
        doc[first_token] ||= {}
        doc[first_token].deep_merge! value
      end
    doc
  end
end
