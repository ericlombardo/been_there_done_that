require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :session
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) } 
  end

  get "/" do
  end

end
