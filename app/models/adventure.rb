class Adventure < ActiveRecord::Base
  belongs_to :user
  has_many :adventure_state_activities
  has_many :activities, through: :adventure_state_activities
  has_many :states, through: :adventure_state_activities

  mount_uploader :image, ImageUploader
  %w(jpg jpeg gif png)
  # validations
  validates :title, :highlight, :summary, presence: true # confirm has email and username

  def slug
    self.title.split(" ").join("-").downcase + "-#{self.id}"

  end

  def self.find_by_slug(slug)

    self.all.find do |a|
      a.slug == slug
    end
  end


end
