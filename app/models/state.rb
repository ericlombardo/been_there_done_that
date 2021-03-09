class State < ActiveRecord::Base
  has_many :adventure_state_activities      # creates associations for models
  has_many :activities, through: :adventure_state_activities
  has_many :adventures, through: :adventures_state_activities
  has_many :users, through: :adventure_state_activities

end