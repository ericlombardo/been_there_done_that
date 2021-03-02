module Helpers
  module InstanceMethods
    
    def logged_in?
      !!session[:user_id]
    end

    def block_not_logged_in
      redirect "/login" if !logged_in?
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

    def get_all_users
      @users = User.all
    end

    def get_all_adventures
      @adventures = Adventure.all
    end

    def get_all_states
      @states = State.all
      @states = @states.sort_by {|s| s.name}
    end

    def get_all_activities
      @activities = Activity.all
      @activities = @activities.sort_by {|a| a.name}
    end

    def profile_creator?
      params[:id].to_i == session_id
    end

    def format_date(date)
      date.strftime("%d/%m/%Y") if !date.nil?
    end

    def valid(model)
      model.valid?
    end

  module ClassMethods

  end
end