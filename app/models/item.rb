class Item
  extend ActiveModel::Naming

  FIELDS = [
    :id, :title, :description, :subject, :creator, :type, :publisher,
    :format, :rights, :contributor, :created, :spatial, :temporal,
    :language, :source, :isPartOf, :preview_source_url
  ]
    .each { |field| attr_accessor field }

  def initialize(doc)
    FIELDS.each { |f| self.send "#{f}=", doc[f.to_s] }
    if doc['dplaSourceRecord'].present?
      self.language = doc['dplaSourceRecord']['language']
    end
  end

  def created_date
    @created['displayDate']
  end

  # returns array with names
  def subject
    @subject.map{|l| l["name"]}
  end

  # returns array with names
  def location
    @spatial.map{|l| l.values.join(', ')}
  end

  def publisher
    Array @publisher
  end

  def url
    @source
  end
end