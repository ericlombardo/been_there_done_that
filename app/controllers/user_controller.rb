class UserController < ApplicationController

  get "/users/:id" do
    block_if_logged_out   #logged_in? helper method
    @user = User.find(params[:id])
    @states = @user.adventures.collect {|a| a.states.uniq}.flatten    # get all states for that user, not doubled up
    @activities = @user.adventures.collect{|a| a.activities}.flatten  # get all activities for that user
  
    # loops through states, create new hash set value to (0) if no value, create key/value for state.name/count
    state_count = @states.each_with_object(Hash.new(0)) {|state, hash| hash[state.name] += 1}   
    activity_count = @activities.each_with_object(Hash.new(0)) {|activity, hash| hash[activity.name] += 1}
  
    @top_states = state_count.max(3) {|a, b| a[1] <=> b[1]}   # loop through state_count to collect top 3
    @top_activities = activity_count.max(3) {|a, b| a[1] <=> b[1]}

    erb :"users/show"
  end

  # post "/users" do
  #   redirect "/users"
  # end

  delete "/users/:id" do
    block_if_logged_out
    if profile_creator? # logged_in? helper
      find_user.destroy
      session.clear
      redirect "/login"
    end
  end

  get "/users/:id/adventures" do
    block_if_logged_out
    @adventures = find_user.adventures
    erb :"users/show_adventures"
  end
end

# @states.each_with_object(Hash.new(0)) {|state, hash| hash[state.name] += 1}     => found example of this on http://jerodsanto.net