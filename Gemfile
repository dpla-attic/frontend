source 'https://rubygems.org'

gem 'rails'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
  gem 'jquery-rails'
end

gem 'haml'
gem 'haml-rails'
gem 'simple_form'
gem 'breadcrumbs_on_rails'
gem 'kaminari'
gem 'navigasmic'

gem 'httparty'
gem 'elastictastic'
gem 'devise'
gem 'rails_config', :git => 'git://github.com/railsjedi/rails_config.git'
gem "leaflet-rails", "~> 0.5.0"
gem "leaflet-markercluster-rails", "~> 0.2.1"
gem 'google-analytics-rails'

group :development do
  gem 'thin'
  gem 'sqlite3'
  gem 'capistrano-deploy', :require => false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'shoulda'
  gem 'shoulda-matchers'
end

group :production do
	gem 'pg', :require => 'pg'
end
