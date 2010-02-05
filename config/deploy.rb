

default_run_options[:pty] = true
 
set :application, "stufftheysaid"
set :user, "tonyrobots"
set :repository,  "git@github.com:tonyrobots/stuff_they_said.git"
set :port, 30007
 
set :runner, "tony"
set :use_sudo, false
 
set :deploy_to, "/www/#{application}"
 
 
set :scm, "git"
set :scm_passphrase, "33sh33d" 
 
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
