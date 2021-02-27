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
      # link user to adventure
      adventure.user_id = session_id
      #saves adventure
      adventure.save
      # link states to adventure
      states = State.find(params[:state_ids]) # gets states
      states.each.with_index(1) do |s, i| # loops through each one with index
        # creates join table instance using state_id and adventure_id
        s.state_adventures.create(adventure_id: adventure.id) 
        activities = Activity.find(params["state_#{i}_activity_ids"])
        activities.each do |a|
          a.state_activities.create(state_id: s.id)
          a.adventure_activities.create(adventure_id: adventure.id)
        end
        
      end
      binding.pry

    else
      # mes. errors 
      redirect "/adventures/new"
    end
  end
end