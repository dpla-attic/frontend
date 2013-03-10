class Item
  extend ActiveModel::Naming

  def initialize(doc)
    @id            = doc["id"]
    @aggregatedCHO = doc["aggregatedCHO"] || {}
    @originRecord  = doc["originalRecord"] || {}
    @object        = doc["object"] || {}
    @isShownAt     = doc["isShownAt"] || {}
  end

  def id; @id end

  def publisher
    Array @aggregatedCHO['publisher']
  end

  def description; @aggregatedCHO['description'] end

  def title; @aggregatedCHO['title'] end

  def rights; @aggregatedCHO['rights'] end

  def created_date
    @aggregatedCHO['date']['displayDate'] if @aggregatedCHO['date']
  end

  # returns array with names
  def location
    @aggregatedCHO['spatial'].map do |loc|
      l = loc["name"], loc["country"], loc["region"], loc["county"], loc["state"], loc["city"]
      l.compact.join(', ')
    end if @aggregatedCHO['spatial']
  end

  def coordinates
    @aggregatedCHO['spatial'].map{|l| l["coordinates"].split(",") rescue nil}.compact
  end

  def creator; @aggregatedCHO['creator'] end

  # returns array with names
  def subject
    @aggregatedCHO['subject'].map{|l| l["name"]} if @aggregatedCHO['subject']
  end

  def type
    @aggregatedCHO['physicalmedium']
  end

  def url; @isShownAt['@id'] end

  def format
    @isShownAt['format']
  end

  def preview_image
    @object["@id"]
  end

  alias :preview_source_url :preview_image

end