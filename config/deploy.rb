require 'capistrano/ext/multistage'

set :scm, :git
set :repository,  "git://github.com/dpla/frontend.git"
set :stages, %w(development staging)
set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"