source 'https://rubygems.org'

gem 'rails'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'zurb-foundation'
  gem 'therubyracer'
  gem 'jquery-rails'
  gem 'html5shiv-rails'
end

gem 'haml'
gem 'haml-rails'
gem 'simple_form'
gem 'simple-navigation'
gem 'breadcrumbs_on_rails'
gem 'kaminari'

gem 'httparty'
gem 'devise'
gem 'rails_config', :git => 'git://github.com/railsjedi/rails_config.git'

group :development do
  gem 'thin'
  gem 'sqlite3'
  gem 'capistrano-deploy', :require => false
  gem 'quiet_assets'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'shoulda'
  gem 'shoulda-matchers'
end

group :production do
	gem 'pg', :require => 'pg'
end