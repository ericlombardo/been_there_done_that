class AdventureStateActivity < ActiveRecord::Base
  belongs_to :adventure
  belongs_to :activity
  belongs_to :state

  # validations (makes sure it has an adventure so it can be updated)
  validates :adventure, :state, presence: true
end