ENV["SINATRA_ENV"] ||= "development"

require 'dotenv/tasks'
require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'enter into Pry'
task :c do
  Pry.start
end

desc 'loads env. file'
task :env do
  require_relative './config/environment'
end