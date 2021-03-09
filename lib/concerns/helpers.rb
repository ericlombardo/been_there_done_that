module Helpers
  module InstanceMethods

    def block_if_logged_in  # checks for session id, redirects to profile if present
      if !!session_id
        flash[:info] = "No need to login in. We're already acquainted"
        redirect to "/users/#{current_user.slug}"
      end
    end

    def block_if_logged_out #checks for session id, redirects to login if not present
      if !session_id
        flash[:warning] = "Must login to view this content"
        redirect "/login" 
      end
    end

    def session_id  # gives session_id
      session[:user_id]
    end

    def current_user  # uses ID to find the current user instance
      @current_user = User.find_by(id: session_id)
    end

    def find_user # uses slug to get user instance, redirect to profile if not found
      @user = User.find_by_slug(params[:slug])
      if @user.nil? 
        flash[:warning] = "Sorry, couldn't find the adventurer you input"
        redirect to "/users/#{current_user.slug}"
      end
      @user
    end

    def find_adventure  # uses slug to get adventure instance, redirect to adventure index if not found
      @adventure = Adventure.find_by_slug(params[:slug])
      if @adventure.nil?
        flash[:warning] = "Couldn't find that adventure. Here are some that we could find"
        redirect to "/adventures"
      end
      @adventure
    end

    def get_users # gets users if the value isn't already assigned
      @users ||= User.all
    end

    def get_adventures  # gets adventures if the value isn't already assigned
      @adventures ||= Adventure.all
    end

    def get_states  # gets states if the value isn't already assigned, sorts by name
      @states ||= State.all
      @states = @states.sort_by {|s| s.name}
    end

    def get_activities  # gets activities if value isn't already assigned, sorts by name
      @activities ||= Activity.all
      @activities = @activities.sort_by {|a| a.name}
    end

    def profile_creator?  # uses slug to see if current user matches session_id
      User.find_by_slug(params[:slug]).id == session_id
    end

    def adventure_creator?(adventure) # checks user id againsts adventure user id
      session_id == adventure.user_id
    end

    def format_date(date) # formats date to day, month, then year
      date.nil? ? (date) : (date.strftime("%m/%d/%Y"))
    end

    def valid(model)  # checks if model given is valid
      model.valid?
    end

    def link_user_and_save(adventure)  # link user to adventure and saves adventure
      adventure.user_id = session_id   
      adventure.save    
    end

    def gen_adv_log # create [{state: "ohio", activities: "run, jog, walk"}, {state: "Iowa", ect.}]
      i = 0 # set counter
      @adventure_log = [] # generates empty array for info
      @adventure.states.uniq.count.times do # loop through each state in adventure
        state = @adventure.states.uniq[i]  # assign each state to state variable
        # find activities that belong to both that adventure and state, collect array of each activity_id
        activity_ids = AdventureStateActivity.where(adventure_id: @adventure.id, state_id: state.id).pluck(:activity_id)
        if activity_ids.any? {|a| a.nil?}  # check if returned array includes nil (no activities)
          @adventure_log[i] = {state: state, activities: []}
          i += 1
        else
          activity_array = Activity.find(activity_ids)  # get array of activity instances
          @adventure_log[i] = {state: state, activities: activity_array} # create hash item in log with state and activities
          i += 1  # add one to assign next element in array
        end
      end
      @adventure_log
      binding.pry
    end

    def assign_states_and_activities_to_adventure(params, adventure)
      i = 1
      3.times do
        if !!params[:log]["state#{i}"]
          state = State.find_by(id: params[:log]["state#{i}"][:id]) # if we have a state
          # check if we have an activities
          if !!params[:log]["state#{i}"][:activities]
            # if we do loop through them
            activities = Activity.find(params[:log]["state#{i}"][:activities])
            activities.each do |a|  # loop through each activity
              # assign each to adventure.adventurestateactivities.create with state activitiy and adventure
              adventure.adventure_state_activities.create(state_id: state.id, activity_id: a.id) # creates instance of adventure_state_activity if only a state is selected
            end
            i += 1
          else
            # create with just state and adventure
            adventure.adventure_state_activities.create(state_id: state.id) # create instance of adventure_state_activity w/ adv_id and state_id
            i += 1
          end
        else
          # increment up 1 and go to next iteration
          i += 1
        end
      end
    end

    def show_details(adventure) # creates array of HTML strings based on validation of presence
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
end