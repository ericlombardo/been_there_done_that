class AdventureStateActivity < ActiveRecord::Base
  belongs_to :adventure
  belongs_to :activity
  belongs_to :state
end