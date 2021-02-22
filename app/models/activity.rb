class Activity < ActiveRecord::Base
  has_many :adventure_activities
  has_many :adventures, through: :adventure_activities
  has_many :users, through: :adventures
end