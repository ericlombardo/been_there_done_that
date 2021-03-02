require './config/environment'

class ApplicationController < Sinatra::Base
  include Helpers::InstanceMethods

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    register Sinatra::Flash
  end

  get "/" do  # goes to login page to start signing in
    redirect '/login'
  end
  