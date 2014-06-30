class Item
  extend ActiveModel::Naming

  def initialize(doc)
    doc = transform_dotted_keys doc
    @id             = doc['id']
    @sourceResource = doc['sourceResource'] || {}
    @originalRecord = doc['originalRecord'] || {}
    @object         = doc['object']
    @isShownAt      = doc['isShownAt']
    @dataProvider   = doc['dataProvider']
    @provider       = doc['provider']['name'] if doc['provider']
    @score          = doc['score']
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
    description = Array(@sourceResource['description']).each do |x|
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

  def rights
    @sourceResource['rights']
  end

  def created_date
    @sourceResource['date']['displayDate'] rescue nil
  end

  def year
    @sourceResource['date']['begin'].split('-').first rescue nil
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
    @isShownAt
  end

  def format
    @originalRecord['format']
  end

  def preview_image
    @object
  end

  def data_provider
    @dataProvider
  end

  def provider
    @provider
  end

  def score
    @score
  end

  private

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