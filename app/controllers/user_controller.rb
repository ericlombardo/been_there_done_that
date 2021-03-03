class UserController < ApplicationController

  get "/users/:id" do
    if logged_in?
      @user = User.find(params[:id])

      # get all states for that user, not doubled up
      @states = @user.adventures.collect {|a| a.states.uniq}.flatten
      # get all activities for that user, not doubled up
      @activities = @user.adventures.collect{|a| a.activities}.flatten
      # count the instances of each one and find the max(3)
      
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
    @adventures = find_user.adventures
    erb :"users/show_adventures"
  end
end