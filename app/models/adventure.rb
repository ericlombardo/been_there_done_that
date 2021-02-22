class Adventure < ActiveRecord::Base
  belongs_to :user
  has_many :adventure_activities
  has_many :activities, through: :adventure_activities
end
