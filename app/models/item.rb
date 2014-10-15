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
    @hasView                = doc['hasView'] || [{}]
    @provider               = doc['provider']['name'] if doc['provider']
    @score                  = doc['score']
    if @sourceResource['spatial'].present? and not @sourceResource['spatial'].is_a? Array
      @sourceResource['spatial'] = [ @sourceResource['spatial'] ]
    end
    if @sourceResource['date'].present? and not @sourceResource['date'].is_a? Array
      @sourceResource['date'] = [ @sourceResource['date'] ]
    end
    if @sourceResource['subject'].present? and not @sourceResource['subject'].is_a? Array
      @sourceResource['subject'] = [ @sourceResource['subject'] ]
    end
    if @hasView.present? and not @hasView.is_a? Array
      @hasView = [@hasView]
    end
  end

  def id 
    @id
  end

  # Expected data type from API: String or Array of Strings
  # Returns: Array of Strings
  def publisher 
    publisher = Array(@sourceResource['publisher'])
    is_array_of_strings?(publisher, "sourceResource.publisher") ? publisher : nil
  end

  # Expected data type from API: String or Array of Strings
  # Returns: String
  def description 
    description = Array(@sourceResource['description'])
    return nil if !is_array_of_strings?(description, "sourceResource.description")

    description = description.each do |x|
      if x !~ /[.,?!;:]$/
        x << "."
      end
    end

    description.join(" ")
  end

  # Expected data type from API: String or Array of Strings
  # Returns: String
  def title 
    title = Array(@sourceResource['title']).first
    is_valid_string?(title, "first value of sourceResource.title") ? title : nil
  end

  # Expected data type from API: String or Array of Strings
  # Returns: Array of Strings
  def titles(options = {}) 
    titles = []
    if options[:with_first] 
      titles = Array(@sourceResource['title'])
    else
      titles = Array(@sourceResource['title'])[1..-1]
    end
    is_array_of_strings?(titles, "sourceResource.title") ? titles : nil
  end

  # Expected data type from API: String or Array of Strings
  # Returns: Array of Strings
  def rights
    rights = Array(@sourceResource['rights'])
    is_array_of_strings?(rights, "sourceResource.rights") ? rights : nil
  end

  # Expected data type from API: String or Array of Strings
  # Returns: Array of Strings
  def standardized_rights_statement
    statement = Array(@edmRights)
    @hasView.each { |view| statement.push( view['edmRights'] ) }
    is_array_of_strings?(statement.compact, 'edmRights and hasView.edmRights') ? statement.compact : nil
  end

  # Expected data type from API: Strings
  # Returns: String
  def created_date 
    created_date = []

    @sourceResource['date'].each do |date|
      if is_valid_string?(date['displayDate'], 'sourceResource.date.displayDate')
        created_date << date['displayDate']
      end
    end

    created_date.join("; ")
  end

  # Expected data type from API: Strings
  # Returns: String representing the year from the first date value
  def year 
    year = @sourceResource['date'][0]['begin'].split('-').first rescue nil
    year && is_valid_string?(year, "year value for sourceResource.date.begin") ? year : nil
  end

  # Expected data type from API: Strings 
  # Returns: Array of Strings
  def location 
    location = @sourceResource['spatial'].map do |loc|
      l = loc['name'] rescue nil
    end if @sourceResource['spatial'].present?
    is_array_of_strings?(Array(location), 'sourceResource.spatial.name') ? Array(location) : nil
  end

  # Expected data type from API: Strings 
  # Returns: Array of Arrays of Strings ( ie. [['80', '81']] )
  def coordinates 
    coordinates = nil
    if @sourceResource['spatial'].present?
      coordinates = @sourceResource['spatial'].map{ |l| l['coordinates'].split ',' rescue nil }.compact
    end
    coordinates && is_array_of_strings?(coordinates.flatten, 'sourceResource.spatial.coordinates') ? coordinates : nil
  end

  # Expected data type from API: String or Array of Strings
  # Returns: String 
  def creator 
    is_array_of_strings?(Array(@sourceResource['creator']), 'sourceResource.creator') ? 
      Array(@sourceResource['creator']).join('; ') : nil
  end

  # Expected data type from API: Strings
  # Returns: Array of Strings
  def subject 
    subject = @sourceResource['subject'].map{|l| l['name'] rescue nil}
    is_array_of_strings?(subject, 'sourceResource.subject.name') ? subject : nil
  end

  # Expected data type from API: String or Array of Strings
  # Returns: Array of Strings
  def type
    type = Array(@sourceResource['type'])
    is_array_of_strings?(type, 'sourceResource.type') ? type : nil
  end

  # Expected data type from API: String
  # Returns: String
  def url 
    url = @isShownAt.is_a?(Array) ? @isShownAt[0] : @isShownAt
    is_valid_url?(url, 'isShownAt') ? url : nil
  end

  # Exptected data type from API: String or Array of Strings
  # Returns: Array of Strings
  def format 
    format = Array(@sourceResource['format'])
    is_array_of_strings?(format, 'sourceResource.format') ? format : nil
  end

  # Expected data type from API: String
  # Returns: String 
  def preview_image 
    is_valid_url?(@object, 'object') ? @object : nil
  end

  # Expected data type from API: String
  # Returns: String
  def data_provider 
    is_valid_string?(@dataProvider, 'dataProvider') ? @dataProvider : nil
  end

  # Expected data type from API: String
  # Returns: String
  def intermediate_provider 
    is_valid_string?(@intermediateProvider, 'intermediateProvider') ? @intermediateProvider : nil
  end

  # Returns: Array of Strings 
  def contributing_institution 
    [data_provider, intermediate_provider].compact
  end

  # Expected data type from API: String
  # Returns: String 
  def provider 
    is_valid_string?(@provider, 'provider') ? @provider : nil
  end

  # Expected data type from API: Integer
  # Returns: Integer
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

    def is_valid_string?(value, field_name)
      return true if value.is_a? String 
      log_error(@id, field_name, "String", value.class) and return false
    end

    def is_valid_url?(value, field_name)
      return false if !is_valid_string?(value, field_name)
      uri = URI.parse(value)
      return true if uri.kind_of?(URI::HTTP) 
      log_error(@id, field_name, "valid URL", "invalid URL") and return false
    end

    def is_array_of_strings?(value, field_name)
      return false if !value.is_a? Array
      strings = true
      value.each { |x| strings = false if !x.is_a? String }
      return true if strings
      log_error(@id, field_name, "one or more Strings", "one or more non-String values") and return false
    end

    def log_error(id, field, expected_type, actual_type)      
      if actual_type != NilClass
        Rails.logger.error("Parse error for Item #{id} at #{field}: Expected #{expected_type} but got #{actual_type}.")
      end
    end

end