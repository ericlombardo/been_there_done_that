require './config/environment'

class ApplicationController < Sinatra::Base
  include Helpers::InstanceMethods
  extend Helpers::ClassMethods

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
  
  get "/login" do  # show login form, if signed in show profile page
    block_if_logged_in # logged_in? helper method
    erb :login
  end

  get "/signup" do  # shows signup form, if signed in show profile page
    block_if_logged_in  # logged_in? helper method
    erb :signup 
  end

  post "/signup" do # validates input, logs in and shows profile page if valid, reloads if not
    user = User.new(params)
    if valid(user)
      user.save # if valid create user, assign session id, redirect to profile
      session[:user_id] = user.id 
      flash[:success] = "Successful Login"
      redirect to "/users/#{current_user.slug}"
    else
      flash[:danger] = user.errors.full_messages.join(', and ')
      redirect "/signup"
    end
  end

  post "/login" do  # validates pre-existing user, shows profile page or reloads login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Successful Login"
      redirect "/users/#{current_user.slug}"
    else
      flash[:danger] = "No match found. Please try again or click link to signup"
      redirect "/login" 
    end
  end

  post "/logout" do # clears session and redirects to login || redirects to login
    block_if_logged_out # logged_in? helper method
      flash[:success] = "Until next time #{current_user.username}!"
      session.clear
      redirect "/login"
  end
end
