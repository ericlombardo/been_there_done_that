class AdventureStateActivity < ActiveRecord::Base
  belongs_to :adventure   # creates associations for models
  belongs_to :activity
  belongs_to :state

  validates :adventure, :state, presence: true   # validations (makes sure has adventure for updated)
end