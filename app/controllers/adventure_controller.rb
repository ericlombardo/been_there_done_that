class AdventureController < ApplicationController

  
  get "/adventures" do  # get route to show erb :index
    get_adventures
    # if adventures empty, redirect to log adventure, give flash message that no adventures yet, track to be first
    get_states
    get_activities
    erb :"adventures/index"
  end

  get "/adventures/new" do # show form to log a new trip
    get_activities
    get_states
    erb :"adventures/new"
  end

  get '/adventures/:id' do  # Show adventure data based on id
    find_adventure
    erb :"adventures/show"
  end

  post "/adventures" do  # Takes form info, validates truthyness, creates new adventure, links states, user, and activities, or redirects to new form
    adventure = Adventure.new(params[:adventure])
    if valid(adventure)
      link_user_and_save(adventure)   # link user to adventure and saves adventure
      assign_states_and_activities_to_adventure(params, adventure)
      redirect to "/adventures/#{adventure.id}"
    else
      # mes. errors 
      redirect "/adventures/new"
    end
  end

  get "/adventures/:id/edit" do # shows form to edit previous adventure with data filled in
    get_activities
    get_states
    find_adventure

    # loop through each state
    i = 0 # set counter
    @adventure_log = []
    @adventure.states.uniq.count.times do # however many states there are, loop through that many times
      state = @adventure.states.uniq[i]  # get instance of that state
      activity_ids = AdventureStateActivity.where(adventure_id: @adventure.id, state_id: @adventure.states.uniq[i].id).pluck(:activity_id) #=> find adventure_state_activity instances that match adventure.id and state_id
      activity_array = Activity.find(activity_ids)  # get array of activity ideas for that adventure state
      @adventure_log[i] = {state: state, activities: activity_array} # create hash item in log with state and activities
      i += 1
    end

    erb :"adventures/edit"
  end

  patch "/adventures/:id" do # takes in new form data and updates the existing adventure
    find_adventure  # get adventure

    @adventure.update(params[:adventure]) # update adventure details

    AdventureStateActivity.where(adventure_id: @adventure.id).destroy_all # destroy all adventure_state_activities for that adventure
    
    assign_states_and_activities_to_adventure(params, @adventure) # link new adventure_state_activities for updated adventure
    redirect to "/adventures/#{@adventure.id}"
  end

  delete "/adventures/:id" do # get adventure, delete it from the adventures, but not from state activities
    find_adventure.destroy
    redirect to "/users/#{session_id}"
  end

  post "/adventures/state_filter" do
    get_activities
    get_states
    state_ids = AdventureStateActivity.where(state_id: params[:state_filter]).pluck(:adventure_id).uniq
    @state_filter = Adventure.find(state_ids)
    erb :"adventures/index"

  end

  get "/adventures#:state" do
    # show adventures for that state
    # send to adventure index
  end
end