class UserController < ApplicationController

  get "/users/:id" do
    if logged_in?
      @user = User.find(params[:id])
      erb :"users/show"
    else
      redirect "/login"
    end
  end

  post "/users" do
    redirect "/users"
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

  get "/users/:id/adventures" do
    block_not_logged_in
    @adventures = find_user.adventures

    erb :"users/show_adventures"
  end
end