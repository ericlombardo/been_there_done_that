class AdventureActivity < ActiveRecord::Base
  belongs_to :adventure
  belongs_to :activity
end