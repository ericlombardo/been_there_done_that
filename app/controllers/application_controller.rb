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
    redirect to "/login"
  end

  get "/login" do  # if logged in => go to user profile else => show login form
    logged_in? ? (redirect to "/users/#{session_id}") : (erb :login)
  end

  get "/signup" do
    logged_in? ? (redirect to "/users/#{session_id}") : (erb :signup)
  end

  post "/signup" do # take input from params, new user, validate, sign them in, send them to profile

    if User.new(params).valid? # if valid create user, assign session id, redirect to profile
      user = User.create(params)
      session[:user_id] = user.id 
      redirect to "/users/#{session_id}"
    else
      'bingo'
    end
  end


end
