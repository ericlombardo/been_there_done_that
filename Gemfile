source 'http://rubygems.org'

gem 'sinatra' # front end, handles requests and responses
gem 'sinatra-flash' # allows flash messages throughout the application
gem 'activerecord', '~> 5.2', :require => 'active_record' # ORM that sets up database and has helper methods
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'  # lets us use rake tasks with ActiveRecord
gem 'rake'  # allow us to automate tasks like seeding databases or reloading environments
gem 'require_all' # requires all files in a specific directory
gem 'sqlite3', '~> 1.3.6' # used for our database
gem 'thin'  # gives us a web server to run through
gem 'shotgun' # launches our server and allows for updates without closing server
gem 'pry' # allows testing of application
gem 'bcrypt'  # allows password hash, works with has_secure_password to authenticate 
gem 'tux' # sandbox to test ActiveRecord associations
gem 'dotenv'  # allows secure file to place sensitive keys and documentation
gem 'faker' # fills seed database with fake data
gem 'sinatra-contrib', :require => 'sinatra/content_for'  # provides helper methods for yeild :titles

group :development do
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner-active_record'
end
