require './config/environment'


class ApplicationController < Sinatra::Base
  include Helpers::InstanceMethods
  extend Helpers::ClassMethods

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :session
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  get "/" do  # goes to login page to start signing in
    redirect '/login'
  end

  get "/login" do  # if logged in => go to user profile else => show login form
    if logged_in?
      redirect to "/users/#{session_id}"
    else
      erb :login
    end
  end

  get "/signup" do
    logged_in? ? (redirect to "/users/#{session_id}") : (erb :signup)
  end

  post "/signup" do # take input from params, new user, validate, sign them in, send them to profile
    user = User.new(params)
    if user.save # if valid create user, assign session id, redirect to profile
      session[:user_id] = user.id 
      redirect to "/users/#{session_id}"
    else
      redirect "/signup"
    end
  end
end
