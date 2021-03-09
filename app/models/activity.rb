class Activity < ActiveRecord::Base
  has_many :adventure_state_activities    # creates associations for models
  has_many :adventures, through: :adventure_state_activities
  has_many :states, through: :adventure_state_activities
  has_many :users, through: :adventures_state_activities
end