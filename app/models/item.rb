class Item
  FIELDS = [
    :_id, :title, :description, :subject, :creator, :type, :publisher,
    :format, :rights, :contributor, :created, :spatial, :temporal,
    :source, :isPartOf
  ]
    .each { |field| attr_accessor field }

  alias id _id

  def initialize(doc)
    FIELDS.each { |f| self.send "#{f}=", doc[f.to_s] }
  end

  def self.find(ids)
    api.find(ids).map { |doc| self.new doc }
  end

  def self.where(conditions)
    Item::Result.new api.where(conditions)
  end

  private

  def self.api
    @@api ||= DPLA::Item.new
  end
end