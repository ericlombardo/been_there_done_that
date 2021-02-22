class StateActivity < ActiveRecord::Base
  belongs_to :state
  belongs_to :activity
end