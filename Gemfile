source 'https://rubygems.org'

gem 'rails', '~> 3.2.17'
gem 'pg', '~> 0.18.4', :require => 'pg'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '~> 3.0.2'
  gem 'therubyracer', '~> 0.12.2'
  gem 'jquery-rails', '~> 2.1.4'
  gem 'rails-backbone', '~> 0.9.10'
end

gem 'haml', '~> 4.0.7'
gem 'haml-rails', '~> 0.4'
gem 'simple_form', '~> 2.1.3'
gem 'breadcrumbs_on_rails', '~> 2.3.1'
gem 'kaminari', '~> 0.17.0'
gem 'navigasmic', '~> 1.1.0'
gem 'carrierwave', '~> 0.11.2'
gem 'rmagick', '~> 2.16.0'
gem 'page_title_helper', '~> 2.1.0'
gem 'dalli', '~> 2.7.6'
gem 'httparty', '~> 0.14.0'
gem 'devise', '~> 2.2.8'
gem 'rails_config', '~> 0.4.0'
gem 'leaflet-rails', '~> 0.5.0'
gem 'leaflet-markercluster-rails', '~> 0.2.1'
gem 'google-analytics-rails', '~> 1.1.0'
gem 'meta-tags', '~> 2.2.0'
gem 'turnout', '~> 2.3.1'
gem 'net-ssh', '~> 2.9.4'
# rinku versions greater than 2.0.0 require ruby >= 2.0.0
gem 'rinku', '2.0.0'
gem 'json', '~> 1.8.3'
gem 'fog', '~> 1.38.0'
# We don't use those two gems but need to pin them explicitly because of
# the fog metagem dependencies
gem 'fog-google', '~> 0.0.7'
gem 'fog-profitbricks', '~> 0.0.5'

group :development do
  gem 'thin', '~> 1.7.0'
  gem 'quiet_assets', '~> 1.1.0'
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.99.0'
  gem 'shoulda', '~> 3.5.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'awesome_print', '~> 1.7.0'
  gem 'pry', '~> 0.10.4'
  gem 'codeclimate-test-reporter', '~> 0.6.0', group: :test, require: nil
end

group :test do
  gem 'sqlite3', '~> 1.3.11'
end
   
group :production do
  gem 'unicorn', '~> 5.1.0'
end
