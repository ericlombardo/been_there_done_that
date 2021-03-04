module Helpers
  module InstanceMethods
    def logged_in?
      !!session[:user_id]
    end

    def block_not_logged_in
      redirect "/login" if session[:user_id].nil?
    end

    def session_id
      session[:user_id]
    end

    def current_user
      @current_user = User.find_by(id: session_id)
    end

    def find_user
      @user = User.find_by(id: params[:id])
    end

    def find_adventure
      @adventure = Adventure.find_by(id: params[:id])
    end

    def get_users
      @users = User.all
    end

    def get_adventures
      @adventures ||= Adventure.all
    end

    def get_states
      @states = State.all
      @states = @states.sort_by {|s| s.name}
    end

    def get_activities
      @activities = Activity.all
      @activities = @activities.sort_by {|a| a.name}
    end

    def profile_creator?
      params[:id].to_i == session_id
    end

    def format_date(date)
      date.nil? ? (date) : (date.strftime("%d/%m/%Y"))
    end

    def uniq_state_count
      AdventureStateActivity.where(adventure_id: @adventure.id).pluck(:state_id).uniq.count # found #pluck method example here: https://stackoverflow.com/questions/9658881/rails-select-unique-values-from-a-column/9658899
    end

    def valid(model)
      model.valid?
    end

    def link_user_and_save(adventure)  # link user to adventure and saves adventure
      adventure.user_id = session_id   
      adventure.save    
    end

    def assign_states_and_activities_to_adventure(params, adventure)
      states = State.find(params[:state_ids].find_all {|id| id != ""}) # gets states
      states.each.with_index(1) do |s, i| # loops through each one with index
        activities = Activity.find(params["state_#{i}_activity_ids"].find_all {|id| id != ""})   # get activities for that specific state
        activities.each do |a| # loops through each activity for that state
          adventure.adventure_state_activities.create(state_id: s.id, activity_id: a.id) # creates instance for each using activity and adventure ids
        end
      end
    end

    def show_details(adventure) #create a string of html to return in array to iterate through
      @details = []
      @details << "<h5>Rating: #{@adventure.rating} / 10</h5>" unless @adventure.rating.nil?
      @details << "<h5>Would You Recommend: #{@adventure.recommend}</h5>" unless @adventure.recommend.nil?
      @details << "<h5>Trip Start Date: #{format_date(@adventure.start_date)}</h5>" unless @adventure.start_date.nil?
      @details << "<h5>Trip End Date: #{format_date(@adventure.end_date)}</h5>" unless @adventure.end_date.nil?
      @details << "<h5>Weather: #{@adventure.weather}</h5>" unless @adventure.weather.empty?
      @details << "<h5>Miles Covered: #{@adventure.miles_covered}</h5>" unless @adventure.miles_covered.nil?
      @details << "<h5>Transportation: #{@adventure.transportation}</h5>" unless @adventure.transportation.empty?
      @details << "<h5>Companions: #{@adventure.companions}</h5>" unless @adventure.companions.empty?
      @details << "<h5>Food: #{@adventure.food}</h5>" unless @adventure.food.empty?
      @details << "<h5>Trip Summary:</h5>"
      @details << "<h5>#{@adventure.summary}</h5>" 
      @details << "<h5>Private Notes:</h5>" unless @adventure.private_notes.empty?
      @details << "<h5>#{@adventure.private_notes}</h5>" unless @adventure.private_notes.empty?
      @details
    end
  end

  module ClassMethods

  end
end