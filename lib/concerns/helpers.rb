module Helpers
  module InstanceMethods
    def logged_in?
      !!session[:user_id]
    end

    def session_id
      session[:user_id]
    end
  end

  module ClassMethods

  end
end