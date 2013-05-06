require 'capistrano-deploy'

use_recipes :rails, :rails_assets, :multistage, :git, :bundle, :passenger

set :scm, :git
set :repository,  "git://github.com/dpla/frontend.git"
set :keep_releases, 5

set :user, 'ubuntu'
set :use_sudo, false
set :deploy_to, "/var/www/frontend"

set :default_stage, :development

stage :development do
  server '54.245.27.141', :app, :db, :primary => true
  set :branch, "develop"
end

stage :staging do
  server '54.245.164.12', :app, :db, :primary => true
  set :branch, "testing"
end

after 'deploy:setup',  'deploy:database_config'
after 'deploy:update', 'bundle:install'
after 'deploy:update', 'deploy:migrate'
after 'deploy:update', 'deploy:assets:precompile'

namespace :deploy do
  task :database_config do
    run "cd #{deploy_to} && cp config/database.yml.example config/database.yml"
  end
end
