class UserController < ApplicationController

  get '/users' do  # show all users
    binding.pry
    if logged_in?
      @users = User.all
      erb :"users/index"
    else
      redirect "/login"
    end
  end

  get "/users/:id" do
    if logged_in?
      @user = User.find(params[:id])
      erb :"users/show"
    else
      redirect "/login"
    end
  end

  delete "/users/:id" do
    if logged_in?
      find_user.destroy
      session.clear
      redirect "/login"
    else
      redirect "/login"
    end
  end
end