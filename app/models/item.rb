class Item
  extend ActiveModel::Naming

  def initialize(doc)
    doc = transform_dotted_keys doc
    @id            = doc["id"]
    @aggregatedCHO = doc["aggregatedCHO"] || {}
    @originRecord  = doc["originalRecord"] || {}
    @object        = doc["object"] || {}
    @isShownAt     = doc["isShownAt"] || {}
  end

  def id
    @id
  end

  def publisher
    Array @aggregatedCHO['publisher']
  end

  def description
    @aggregatedCHO['description']
  end

  def title
    @aggregatedCHO['title']
  end

  def rights
    @aggregatedCHO['rights']
  end

  def created_date
    @aggregatedCHO['date']['displayDate'] rescue nil
  end

  # returns array with names
  def location
    @aggregatedCHO['spatial'].map do |loc|
      l = loc["name"], loc["country"], loc["region"], loc["county"], loc["state"], loc["city"]
      l.compact.join(', ')
    end if @aggregatedCHO['spatial']
  end

  def coordinates
    latlong = []
    if @aggregatedCHO['spatial'].present?
      if @aggregatedCHO['spatial'].is_a? Array
        latlong = @aggregatedCHO['spatial'].map{ |l| l['coordinates'].split "," rescue nil}.compact
      elsif @aggregatedCHO['spatial']['coordinates'].present?
        if @aggregatedCHO['spatial']['coordinates'].is_a? Array
          latlong = @aggregatedCHO['spatial']['coordinates'].map{ |l| l.split "," rescue nil}.compact
        end
      end
    end
  end

  def creator
    Array(@aggregatedCHO['creator']).join '; '
  end

  def subject
    @aggregatedCHO['subject'].map{|l| l["name"]} if @aggregatedCHO['subject']
  end

  def type
    @aggregatedCHO['physicalmedium']
  end

  def url
    @isShownAt['@id']
  end

  def format
    @isShownAt['format']
  end

  def preview_image
    @object["@id"]
  end

  alias :preview_source_url :preview_image

  private

    def transform_dotted_keys(doc)
      doc.keys
        .select { |k| k.index('.') }
        .select { |k| k =~ /^(aggregatedCHO|object)/ }
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