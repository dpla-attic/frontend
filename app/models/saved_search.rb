class SavedSearch < ActiveRecord::Base
  attr_accessible :term, :filters, :count
  serialize :filters, Hash

  belongs_to :user

  default_scope order('updated_at DESC')

  # TODO: DRY! Refactoring needed, this is bad way to store dates
  def to_params
    a = {q: term}.tap do |f|
      filters.each do |key, value|
        case key
        when :after
          f['after'] ||= {}
          f['after']['year'] = value.year
          f['after']['month'] = value.month
          f['after']['day'] = value.day
        when :before
          f['before'] ||= {}
          f['before']['year'] = value.year
          f['before']['month'] = value.month
          f['before']['day'] = value.day
        else
          f[key] = Array value
        end
      end
    end
  end

  def api_base_path
    api_path = Settings.api.url
    api_path
  end

  def api_key
    "&api_key=#{Settings.api.key}" if Settings.api.key
  end

  def api_url
    conditions = DPLA::Conditions.new({ q: term}.merge(filters).merge(page_size: 0))
    "#{api_base_path}/items?#{conditions}#{api_key}"
  end
end
