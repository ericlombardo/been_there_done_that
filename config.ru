require './config/environment' # loads environment file

# if ActiveRecord::Migrator.needs_migration?
#   raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end

use Rack::MethodOverride  # allows routes other than GET and POST with hidden input 

use UserController  # loads controllers for use
use AdventureController
run ApplicationController # runs this controller as the primary controller
