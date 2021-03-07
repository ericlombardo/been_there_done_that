class AdventureController < ApplicationController

  
  get "/adventures" do  # get route to show erb :index
    block_if_logged_out
    get_adventures
    if @adventures.empty?
      flash[:info] = "No Adventures Yet! Be the first to track an adventures"
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
    erb :"adventures/show"
  end

  post "/adventures" do  # Takes form info, validates truthyness, creates new adventure, links states, user, and activities, or redirects to new form
    adventure = Adventure.new(params[:adventure])
    if valid(adventure)
      link_user_and_save(adventure)   # link user to adventure and saves adventure
      assign_states_and_activities_to_adventure(params, adventure)
      flash[:success] = "New Adventure Created"
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
      flash[:danger] = "This is not the adventure you are looking for. Must be creator to edit"
      redirect to "/adventures/#{@adventure.slug}"
    end
    get_activities
    get_states

    gen_adv_log

    erb :"adventures/edit"
  end

  patch "/adventures/:slug" do # takes in new form data and updates the existing adventure
    find_adventure  # get adventure
    @adventure.update(params[:adventure]) # update adventure details

    AdventureStateActivity.where(adventure_id: @adventure.id).destroy_all # destroy all adventure_state_activities for that adventure
    
    assign_states_and_activities_to_adventure(params, @adventure) # link new adventure_state_activities for updated adventure
    flash[:success] = "Successfully updated adventure"
    redirect to "/adventures/#{@adventure.slug}"
  end

  delete "/adventures/:slug" do # get adventure, delete it from the adventures, but not from state activities
    block_if_logged_out
    find_adventure
    if adventure_creator?(@adventure)
      AdventureStateActivity.where(adventure_id: @adventure.id).destroy_all
      @adventure.destroy 
      flash[:succes] = "Successfully deleted adventure"
      redirect to "/users/#{current_user.slug}/adventures"
    end
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
      redirect to "/adventures"
    end

    if Adventure.find(filter_ids).empty? # check if there are any adventures for those filtered results
      flash[:info] = "No adventures met this criteria"
      redirect to "/adventures"
    else
      @filtered = Adventure.find(filter_ids)
      erb :"adventures/index"
    end
  end
end