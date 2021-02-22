ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

configure :development do   # found on a learn lesson
  set :database, 'sqlite3:db/development.sqlite'
end
configure :test do
  set :database, 'sqlite3:db/test.sqlite'
end

Dotenv.load


ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

 # check if getting rid of this breaks anything should do the same as line 12
require './app/controllers/application_controller' 
require_all 'app'
