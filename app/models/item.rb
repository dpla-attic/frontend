class Item
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

  def self.find(id)
    self.new api.find(id).first
  end

  def self.where(conditions)
    Item::Result.new api.where(conditions)
  end

  private

  def self.api
    @@api ||= DPLA::Item.new
  end
end