require './config/environment'

class ApplicationController < Sinatra::Base
  include Helpers::InstanceMethods  # includes instance methods from helpers file
  helpers Sinatra::ContentFor # allows content_for to work

  configure do
    set :public_folder, 'public'  # sets route for public folder
    set :views, 'app/views'       # sets route for views folder
    enable :sessions              # enables sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }   # creates session_secret from environment variable or securerandom
    register Sinatra::Flash       # enables the use of Sinatra Flash
  end

  get "/" do  # redirects to login page
    redirect '/login'
  end
  
  get "/login" do  # redirects if signed in || shows login view
    block_if_logged_in  
    erb :login
  end

  get "/signup" do  # redirects if signed in || shows signup view
    block_if_logged_in
    erb :signup 
  end

  post "/signup" do # creates user or redirects with error messages
    user = User.new(params) # creates new user
    if valid(user)  # checks if valid
      user.save # saves user
      session[:user_id] = user.id   # links user.id to current user (logs in)
      flash[:success] = "Successful Login"
      redirect to "/users/#{current_user.slug}" # redirects to profile page
    else
      flash[:danger] = user.errors.full_messages.join(', and ')
      redirect "/signup"  # redirects to signup with errors if not valid
    end
  end

  post "/login" do  # validates pre-existing user, shows profile page or reloads login
    user = User.find_by(username: params[:username])  # finds user
    if user && user.authenticate(params[:password]) # authenticates their info
      session[:user_id] = user.id   # links user.id to current user (logs in)
      flash[:success] = "Successful Login"
      redirect "/users/#{current_user.slug}"  # redirects to user profile
    else
      flash[:danger] = "No match found. Please try again or click link to sign up"
      redirect "/login"  # if not redirects to login
    end
  end

  get "/logout" do # clears session and redirects to login || redirects to login
    block_if_logged_out
    flash[:success] = "Until next time #{current_user.username}!"
    session.clear
    redirect "/login"
  end
end
