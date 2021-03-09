class UserController < ApplicationController

  get "/users/:slug" do   # find user, collect info for displaying, show "users/show" view
    block_if_logged_out 
    find_user   # find_user

    @state_list = []  # create array to push info into
    # get all states for that user, no join table duplicates
    states = @user.adventures.collect {|a| a.states.uniq}.flatten    
    # loops through states,create hash with default value 0, #=> hash[ohio] => 4
    state_count = states.each_with_object(Hash.new(0)) {|state, hash| hash[state.name] += 1}
    # loop through state_count to collect top 3, [1] gets value and not key
    @top_states = state_count.max(3) {|a, b| a[1] <=> b[1]}
    # once total count is finished collect uniq states in state_list for display
    states.uniq.each {|s| @state_list << s.name} 

    @activity_list = []  # same as above to find top activities
    activities = @user.adventures.collect{|a| a.activities}.flatten  # get all activities for that user
    activity_count = activities.each_with_object(Hash.new(0)) {|activity, hash| hash[activity.name] += 1} # create key value pair with count for each activity
    @top_activities = activity_count.max(3) {|a, b| a[1] <=> b[1]} # collec the top three activities
    activities.uniq.each {|a| @activity_list << a.name}

    erb :"users/show"
  end

  delete "/users/:slug" do  # deletes user, adventure, and join table instances for that user
    block_if_logged_out
    if profile_creator? # double validation they are current user
      adventure_ids = current_user.adventures.pluck(:id)  # gets array of adventure ids for user
      AdventureStateActivity.where(adventure_id: adventure_ids).destroy # deletes instances from trijoin
      current_user.destroy # deletes current user and adventures
      session.clear   # clears session information
      flash[:alert] = "Sorry to see you go. Your account has been deleted"
      redirect "/login" # redirects to login
    else
      redirect to "/users/#{current_user.slug}" # redirects to profile if not right user
    end
  end

  get "/users/:slug/adventures" do  # finds adventures for specific user, show view
    block_if_logged_out
    @adventures = find_user.adventures
    erb :"users/show_adventures"
  end
end

# each_with_object(Hash.new(0)) example found on http://jerodsanto.net