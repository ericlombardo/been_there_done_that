class AdventureController < ApplicationController

  
  get "/adventures" do  # get route to show erb :index
    block_if_logged_out
    get_adventures
    # if adventures empty, redirect to log adventure, give flash message that no adventures yet, track to be first
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

  get '/adventures/:id' do  # Show adventure data based on id
    block_if_logged_out
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
    block_if_logged_out
    find_adventure
    redirect to "/adventures/#{params[:id]}" if !adventure_creator?(@adventure)
    get_activities
    get_states

    gen_adv_log

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
    block_if_logged_out
    find_adventure
    @adventure.destroy if adventure_creator?(@adventure)
    redirect to "/users/#{current_user.slug}"
  end

  post "/adventures/filtered" do
    get_activities
    get_states
    ids = params[:filter_ids]

    case ids.collect {|id| id.empty?}
    when [false, false]
      filter_ids = AdventureStateActivity.where(state_id: ids[0], activity_id: ids[1]).pluck(:adventure_id).uniq
    when [false, true]
      filter_ids = AdventureStateActivity.where(state_id: ids[0]).pluck(:adventure_id).uniq
    when [true, false]
      filter_ids = AdventureStateActivity.where(activity_id: ids[1]).pluck(:adventure_id).uniq
    else [true, true]
      # message no trips meet that criteria
      redirect to "/adventures"
    end
    if Adventure.find(filter_ids).empty?
      redirect to "/adventures"
    else
      @filtered = Adventure.find(filter_ids)
      erb :"adventures/index"
    end
  end
end