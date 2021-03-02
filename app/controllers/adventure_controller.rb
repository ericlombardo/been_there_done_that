class AdventureController < ApplicationController

  
  get "/adventures" do  # get route to show erb :index
    get_adventures
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
    binding.pry
    # format a hash that has 
    # {state name: name value, activities: [activities]}
    # state name key
    # do bottom way state name => array of instaces of activity
    # i = 0
    # until i == 3
      # state.count.do 
      # i += 1
      # creaete empty path
    erb :"adventures/edit"
  end

  patch "/adventures/:id" do # takes in new form data and updates the existing adventure
    find_adventure  # get adventure
    binding.pry
    @adventure.update(params[:adventure]) # update adventure details

    AdventureStateActivity.where(adventure_id: @adventure.id).destroy_all
    
    assign_states_and_activities_to_adventure(params, @adventure)
    binding.pry
    redirect to "/adventures/#{@adventure.id}"
  end
end