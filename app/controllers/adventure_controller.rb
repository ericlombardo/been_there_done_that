class AdventureController < ApplicationController

  get "/adventures" do  # get adventures, states, and activities, show view
    block_if_logged_out
    get_adventures  
    if @adventures.empty?
      flash[:info] = "No Trips Yet! Be the first to track a trip"
      redirect to "/users/#{current_user.slug}"
    end
    get_states
    get_activities
    erb :"adventures/index"
  end

  get "/adventures/new" do # show form to log a new trip
    block_if_logged_out
    get_activities
    get_states
    erb :"adventures/new"
  end

  get '/adventures/:slug' do  # Show adventure data based on id
    block_if_logged_out
    find_adventure
    gen_adv_log 
    erb :"adventures/show"
  end

  post "/adventures" do  # Takes form info, validates truthyness, creates new adventure, links states, user, and activities, or redirects to new form
    adventure = Adventure.new(params[:adventure])
    if valid(adventure)
      link_user_and_save(adventure)   # link user to adventure and saves adventure
      assign_states_and_activities_to_adventure(params, adventure)
      flash[:success] = "New Trip Created"
      redirect to "/adventures/#{adventure.slug}"
    else
      flash[:danger] = adventure.errors.full_messages
      redirect "/adventures/new"
    end
  end

  get "/adventures/:slug/edit" do # shows form to edit previous adventure with data filled in
    block_if_logged_out
    find_adventure
    if !adventure_creator?(@adventure)
      flash[:danger] = "This is not the trip you are looking for. Must be creator to edit"
      redirect to "/adventures/#{@adventure.slug}"
    end
    get_activities
    get_states

    gen_adv_log # returns an array, each element has state and activities key if present

    erb :"adventures/edit"
  end

  patch "/adventures/:slug" do # takes in new form data and updates the existing adventure
    find_adventure  # get adventure
    @adventure.update(params[:adventure]) # update adventure details

    AdventureStateActivity.where(adventure_id: @adventure.id).destroy_all # destroy all adventure_state_activities for that adventure
    
    assign_states_and_activities_to_adventure(params, @adventure) # link new adventure_state_activities for updated adventure
    flash[:success] = "Successfully updated trip"
    redirect to "/adventures/#{@adventure.slug}"  # redirects to adventure/slug view
  end

  delete "/adventures/:slug" do # get adventure, delete it from the adventures, but not from state activities
    block_if_logged_out
    find_adventure
    if adventure_creator?(@adventure) # check if user created adventure
      AdventureStateActivity.where(adventure_id: @adventure.id).destroy_all # finds by trijoin table
      @adventure.destroy   # deletes that adventure
      redirect to "/users/#{current_user.slug}/adventures"  # takes user to users other adventures
    end
  end

  post "/adventures/filtered" do  # gets filtered adventures if present
    get_activities
    get_states
    ids = params[:filter_ids] # collects values for filter ids

    case ids.collect {|id| id.empty?} # use ids to see case 
    when [false, false] # both have values
      filter_ids = AdventureStateActivity.where(state_id: ids[0], activity_id: ids[1]).pluck(:adventure_id).uniq
    when [false, true]  # 1 has value, 2 empty
      filter_ids = AdventureStateActivity.where(state_id: ids[0]).pluck(:adventure_id).uniq
    when [true, false]  # 1 empty, 2 has value
      filter_ids = AdventureStateActivity.where(activity_id: ids[1]).pluck(:adventure_id).uniq
    else [true, true] # both empty
      redirect to "/adventures"
    end

    if Adventure.find(filter_ids).empty? # check if there are any adventures for those filtered results
      flash[:info] = "No adventures met this criteria"
      redirect to "/adventures" # if empty, return to adventures with message
    else
      @filtered = Adventure.find(filter_ids)  # assign adventures to @filtered to show in view
      erb :"adventures/index"
    end
  end
end