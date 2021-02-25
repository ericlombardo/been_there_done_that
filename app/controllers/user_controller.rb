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
    binding.pry
    @user = User.find(params[:id])
    erb :"users/show"
  end

  delete "/users/:id" do
    find_user.destroy
    redirect "/login"
  end
end