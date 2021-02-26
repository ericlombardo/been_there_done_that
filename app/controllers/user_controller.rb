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
end