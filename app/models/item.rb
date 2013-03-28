class Item
  extend ActiveModel::Naming

  def initialize(doc)
    doc = transform_dotted_keys doc
    @id            = doc["id"]
    @sourceResource = doc["sourceResource"] || {}
    @originalRecord  = doc["originalRecord"] || {}
    @object        = doc["object"]
    @isShownAt     = doc["isShownAt"]
  end

  def id
    @id
  end

  def publisher
    Array @sourceResource['publisher']
  end

  def description
    @sourceResource['description']
  end

  def title
    @sourceResource['title']
  end

  def rights
    @sourceResource['rights']
  end

  def created_date
    @sourceResource['date']['displayDate'] rescue nil
  end

  def year
    @sourceResource['date']['displayDate'].split('-').first rescue nil
  end

  # returns array with names
  def location
    location = @sourceResource['spatial'].map do |loc|
      l = loc["name"], loc["country"], loc["region"], loc["county"], loc["state"], loc["city"]
      l.compact.join(', ')
    end if @sourceResource['spatial']
    Array location
  end

  def coordinates
    latlong = []
    if @sourceResource['spatial'].present?
      if @sourceResource['spatial'].is_a? Array
        latlong = @sourceResource['spatial'].map{ |l| l['coordinates'].split "," rescue nil}.compact
      elsif @sourceResource['spatial']['coordinates'].present?
        if @sourceResource['spatial']['coordinates'].is_a? Array
          latlong = @sourceResource['spatial']['coordinates'].map{ |l| l.split "," rescue nil}.compact
        end
      end
    end
  end

  def creator
    Array(@sourceResource['creator']).join '; '
  end

  def subject
    @sourceResource['subject'].map{|l| l["name"]} if @sourceResource['subject']
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

  alias :preview_source_url :preview_image

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