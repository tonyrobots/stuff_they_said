

default_run_options[:pty] = true
 
set :application, "aboutme"
set :user, "dodeja"
set :repository,  "git@github.com:dodeja/aboutme.git"
set :port, 30007
 
set :runner, "dodeja"
set :use_sudo, false
 
set :deploy_to, "/home/dodeja/www/#{application}"
 
 
set :scm, "git"
set :scm_passphrase, "a317dmx" 
 
set :branch, "master"
 
 set :shared_host, "204.232.206.167"
set :location, "204.232.206.167"
 
role :app, location
role :web, location
role :db,  location, :primary => true
 
 
 
namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :start do 
       # nothing 
  end
end
