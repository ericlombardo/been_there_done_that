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

  get "/login" do  # show login form, if signed in show profile page
    if logged_in?
      redirect to "/users/#{session_id}"
    else
      erb :login
    end
  end

  get "/signup" do  # shows signup form, if signed in show profile page
    logged_in? ? (redirect to "/users/#{session_id}") : (erb :signup)
  end

  post "/signup" do # validates input, logs in and shows profile page if valid, reloads if not
    user = User.new(params)
    if user
      user.save # if valid create user, assign session id, redirect to profile
      session[:user_id] = user.id 
      # add message saying successfully logged in
      redirect to "/users/#{session_id}"
    else
      # add message showing errros
      redirect "/signup"
    end
  end

  post "/login" do  # validates pre-existing user, shows profile page or reloads login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # add message saying successfully logged in
      redirect "/users/#{session_id}"
    else
      # add message saying no match. retry or click link to signup
      redirect "/login" 
    end
  end

  post "/logout" do # clears session and redirects to login || redirects to login
    if logged_in?
      session.clear
      # mes. successfully logged out, until next time
      redirect "/login"
    else
      # mes. must be logged in to logout
      redirect "/login"
    end
  end
end
