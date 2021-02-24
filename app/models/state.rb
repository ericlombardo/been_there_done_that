class State < ActiveRecord::Base
  has_many :state_activities
  has_many :activities, through: :state_activities
  has_many :state_adventures
  has_many :adventures, through: :state_adventures
  has_many :users, through: :adventures

end