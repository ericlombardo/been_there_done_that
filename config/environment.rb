ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])


configure :development do   # found on a learn lesson
  set :database, 'sqlite3:db/development.sqlite'
end

Dotenv.load

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require_all 'lib'
require './app/controllers/application_controller' 
require './app/controllers/user_controller'
require './app/controllers/adventure_controller'
require_all 'app'
