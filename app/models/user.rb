class User < ActiveRecord::Base
  has_secure_password
  has_many :adventures
  has_many :activities, through: :adventures
  has_many :states, through: :adventures

  validates_associated :adventures, :activities, :states  # validates associations
  
  validates :username, :email, presence: true # confirm has email and username
  validates :password, length: { minimum: 7 }, unless: :no_password # confirm has password
  validates :username, uniqueness: { message: "%{value} is already taken. Try a different username"}, unless: :no_username  # confirm unique password
  validates :email, format: { with: /.{1,}@[^.]{1,}/, message: "is not valid"}, unless: :no_email  # confirm email format (got regex from sigparser.com)
  
  def slug
    self.username.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.all.find do |u|
      u.slug == slug
    end
  end
  
  def no_password
    !password
  end

  def no_username
    !username
  end

  def no_email
    !email
  end
end