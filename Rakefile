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

desc 'execute state_info_scraper'
task :scrape => :env do
  StateInfoScraper.new.scrape("https://www.infoplease.com/us/states")
end