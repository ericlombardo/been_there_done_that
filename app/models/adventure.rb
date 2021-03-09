class Adventure < ActiveRecord::Base
  belongs_to :user      # creates associations for models
  has_many :adventure_state_activities
  has_many :activities, through: :adventure_state_activities
  has_many :states, through: :adventure_state_activities

  validates :title, :highlight, :summary, presence: true  # validates presence

  def slug  # creates slug from adventure id
    self.title.split(" ").join("-").downcase + "-#{self.id}"
  end

  def self.find_by_slug(slug) # finds adventure by slug

    self.all.find do |a|
      a.slug == slug
    end
  end


end
