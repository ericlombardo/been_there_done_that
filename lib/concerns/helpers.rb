module Helpers
  module InstanceMethods
    # logged_in? helper method => !!session[:user_id]
    def block_if_logged_in
      if !!session_id
        flash[:info] = "No need to login in. We're already acquainted"
        redirect to "/users/#{current_user.slug}" if !!session_id
      end
    end

    def block_if_logged_out
      if !session_id
        flash[:warning] = "Must login to view this content"
        redirect "/login" 
      end
    end

    def session_id
      session[:user_id]
    end

    def current_user
      @current_user = User.find_by(id: session_id)
    end

    def find_user
      @user = User.find_by_slug(params[:slug])
      if @user.nil?
        flash[:warning] = "Sorry, couldn't find the adventurer you input"
        redirect to "/users/#{current_user.slug}"
      end
    end

    def find_adventure
      @adventure = Adventure.find_by_slug(params[:slug])
      if @adventure.nil?
        flash[:warning] = "Couldn't find that adventure. Here are some that we could find"
        redirect to "/adventures"
      end
    end

    def get_users
      @users ||= User.all
    end

    def get_adventures
      @adventures ||= Adventure.all
    end

    def get_states
      @states ||= State.all
      @states = @states.sort_by {|s| s.name}
    end

    def get_activities
      @activities ||= Activity.all
      @activities = @activities.sort_by {|a| a.name}
    end

    def profile_creator?
      User.find_by_slug(params[:slug]).id == session_id
    end

    def adventure_creator?(adventure)
      session_id == adventure.user_id
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

    def gen_adv_log
      i = 0 # set counter
      @adventure_log = []
      @adventure.states.uniq.count.times do # however many states there are, loop through that many times
        state = @adventure.states.uniq[i]  # get instance of that state
        activity_ids = AdventureStateActivity.where(adventure_id: @adventure.id, state_id: @adventure.states.uniq[i].id).pluck(:activity_id) #=> find adventure_state_activity instances that match adventure.id and state_id
        activity_array = Activity.find(activity_ids)  # get array of activity ideas for that adventure state
        @adventure_log[i] = {state: state, activities: activity_array} # create hash item in log with state and activities
        i += 1
      end
      @adventure_log
    end

    def assign_states_and_activities_to_adventure(params, adventure)
      i = 1
      3.times do
        if !!params[:log]["state#{i}"] # if state "i" is there
          state = State.find_by(id: params[:log]["state#{i}"][:id]) # get that state
          if !!params[:log]["state#{i}"][:activities] # if state state has activities
            activities = Activity.find(params[:log]["state#{i}"][:activities])
            activities.each do |a|  # loop through each activity
              adventure.adventure_state_activities.create(state_id: state.id, activity_id: a.id) # creates instance of adventure_state_activity if only a state is selected
            end
            i += 1
          else  # it doesn't have activities
            adventure.adventure_state_activities.create(state_id: state.id) # create instance of adventure_state_activity w/ adv_id and state_id
            i += 1
          end
        else
          i += 1
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
      @details << "<h5>Private Notes:</h5>" unless @adventure.private_notes.empty? || !adventure_creator?(@adventure)
      @details << "<h5>#{@adventure.private_notes}</h5>" unless @adventure.private_notes.empty? || !adventure_creator?(@adventure)
      @details
    end
  end

  module ClassMethods

  end
end