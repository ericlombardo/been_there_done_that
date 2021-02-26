class AdventureController < ApplicationController

  # get route to show erb :index
  get "/adventures" do 
    get_adventures
    erb :"adventures/index"
  end

  post '/adventures' do
    redirect "/adventures"
  end

  get '/adventures/:id' do  #Create show page for each adventure, decide what is public what is private
    find_adventure
    erb :"adventures/show"
  end

end