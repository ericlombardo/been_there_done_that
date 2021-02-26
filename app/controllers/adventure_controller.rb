class AdventureController < ApplicationController

  # get route to show erb :index
  get "/adventures" do 
    get_adventures
    erb :"adventures/index"
  end

  get "/adventures/new" do # show form to log a new trip
    get_activities
    get_states
    erb :"adventures/new"
  end

  get '/adventures/:id' do  #Create show page for each adventure, decide what is public what is private
    find_adventure
    erb :"adventures/show"
  end


  post "/adventures" do
    adventure = Adventure.new(params[:adventure])
    if adventure.save
      adventure.user_id = current_user

      states = State.find(params[:states])
      activities = Activity.find(params[:activities])
      adventure.states << states
      adventure.activities << activities 
      binding.pry
    else
      # mes. errors 
      redirect "/adventures/new"
    end
  end
end