ENV['SINATRA_ENV'] ||= "development"  # checks if ENV variable has value, if not sets it to "development"

require 'bundler/setup' # requires bundler
Bundler.require(:default, ENV['SINATRA_ENV']) # requires gems in Gemfile


configure :development do    # tells development environment what database to use (found on a learn lesson)
  set :database, 'sqlite3:db/development.sqlite'
end

Dotenv.load 

ActiveRecord::Base.establish_connection(  # establishes connection to whatever database the environment is set to
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require_all 'lib' # requires files in lib folder
require './app/controllers/application_controller'  # requires controllers needed to operate
require './app/controllers/user_controller'
require './app/controllers/adventure_controller'
require_all 'app'
