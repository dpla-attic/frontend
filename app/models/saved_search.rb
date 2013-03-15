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
    Rails.logger.debug a.inspect
    a
  end
end
