# ENV["SINATRA_ENV"] ||= "development"

require 'dotenv/tasks'
require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'enter into Pry'
task :c => :env do
  Pry.start
end

desc 'loads env. file'
task :env do
  require_relative './config/environment'
end

desc 'reload files'
task :reload! do
  load_all "./config" if Dir.exists?("./config")
  load_all "./app" if Dir.exists?("./app")
  load_all "./lib" if Dir.exists?("./lib")
  load_all "./*.rb" if Dir.entries(".").include?(/\.rb/)
  puts "bingo"
end