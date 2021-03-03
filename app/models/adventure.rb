class Adventure < ActiveRecord::Base
  belongs_to :user
  has_many :adventure_state_activities
  has_many :activities, through: :adventure_state_activities
  has_many :states, through: :adventure_state_activities

  # validations
  validates :title, :highlight, :summary, presence: true # confirm has email and username
end
