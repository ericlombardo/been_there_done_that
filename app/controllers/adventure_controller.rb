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
    
    if adventure.valid?
      adventure.user_id = session_id    # link user to adventure
      adventure.save    #saves adventure
      states = State.find(params[:state_ids]) # gets states
      states.each.with_index(1) do |s, i| # loops through each one with index
        # creates join table instance using state_id and adventure_id
        s.state_adventures.create(adventure_id: adventure.id) 
        activities = Activity.find(params["state_#{i}_activity_ids"])   # get activities for that specific state
        activities.each do |a| # loops through each activity for that state
          a.state_activities.create(state_id: s.id)   # creates instance for each using state and activity id
          a.adventure_activities.create(adventure_id: adventure.id) # creates instance for each using activity and adventure ids
        end
      end
      redirect to "/adventures/#{adventure.id}"
    else
      # mes. errors 
      redirect "/adventures/new"
    end
  end

  get "/adventures/:id/edit" do
    erb :"adventures/edit"
  end
end