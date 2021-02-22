class Activity < ActiveRecord::Base
  has_many :adventure_activities
  has_many :adventures, through: :adventure_activities
  has_many :users, through: :adventures
  has_many :state_activities
  has_many :states, through: :state_activities
end