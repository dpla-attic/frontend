server '54.245.27.141', :app
set :user, 'capistrano'
set :use_sudo, false
set :deploy_to, "/var/www/frontend"
set :branch, "master"

namespace :deploy do
  task :restart do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

