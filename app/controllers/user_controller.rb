class UserController < ApplicationController

  get '/users' do
    # show all users
    if logged_in?
      @users = User.all
      erb :"users/index"
    else
      redirect "/login"
    end
  end

  get "/users/:id" do
    "bingo"
  end
end