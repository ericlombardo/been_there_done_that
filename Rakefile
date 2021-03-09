require 'dotenv/tasks'  # gives access to dotenv tasks with rake
require_relative './config/environment' # loads environment file
require 'sinatra/activerecord/rake' # gives access to rake tasks 

desc 'enter into Pry' # enters into Pry session for testing
task :c => :env do
  Pry.start
end

desc 'loads env. file'  # loads environment file to make sure everything can load properly
task :env do
  require_relative './config/environment'
end

