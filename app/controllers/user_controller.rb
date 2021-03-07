class UserController < ApplicationController

  get "/users/:slug" do
    block_if_logged_out   #logged_in? helper method
    find_user

    @state_list = []
    states = @user.adventures.collect {|a| a.states.uniq}.flatten    # get all states for that user, no join table duplicates
    state_count = states.each_with_object(Hash.new(0)) {|state, hash| hash[state.name] += 1}   # loops through states, create new hash set value to (0) if no value, create key/value for state.name/count
    @top_states = state_count.max(3) {|a, b| a[1] <=> b[1]}   # loop through state_count to collect top 3
    states.uniq.each {|s| @state_list << s.name} # once total count is finished collect uniq states in state_list for display

    @activity_list = []
    activities = @user.adventures.collect{|a| a.activities}.flatten  # get all activities for that user
    activity_count = activities.each_with_object(Hash.new(0)) {|activity, hash| hash[activity.name] += 1} # create key value pair with count for each activity
    @top_activities = activity_count.max(3) {|a, b| a[1] <=> b[1]} # collec the top three activities
    activities.uniq.each {|a| @activity_list << a.name}

    erb :"users/show"
  end

  delete "/users/:slug" do
    block_if_logged_out
    if profile_creator? # logged_in? helper
      adventure_ids = current_user.adventures.pluck(:id)
      AdventureStateActivity.where(adventure_id: adventure_ids).destroy
      current_user.destroy
      session.clear
      flash[:alert] = "Sorry to see you go. Your account has been deleted"
      redirect "/login"
    else
      redirect to "/users/#{current_user.slug}"
    end
  end

  get "/users/:slug/adventures" do
    block_if_logged_out
    @adventures = find_user.adventures
    erb :"users/show_adventures"
  end
end

# @states.each_with_object(Hash.new(0)) {|state, hash| hash[state.name] += 1}     => found example of this on http://jerodsanto.net