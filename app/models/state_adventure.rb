class StateAdventure < ActiveRecord::Base
  belongs_to :state
  belongs_to :adventure
end