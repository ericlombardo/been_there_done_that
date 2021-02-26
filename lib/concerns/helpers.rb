module Helpers
  module InstanceMethods
    def logged_in?
      !!session[:user_id]
    end

    def session_id
      session[:user_id]
    end

    def find_user
      @user = User.find(params[:id])
    end

    def find_adventure
      @adventure = Adventure.find(params[:id])
    end

    def get_users
      @users = User.all
    end

    def get_adventures
      @adventures = Adventure.all
    end

    def get_states
      @states = State.all
    end

    def get_activities
      @activities = Activity.all
    end

    def creator?
      params[:id].to_i == session_id
    end
  end

  module ClassMethods

  end
end