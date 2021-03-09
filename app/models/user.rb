class User < ActiveRecord::Base
  has_secure_password # used with bcrypt to give methods to authenticate passwords
  has_many :adventures, dependent: :destroy # creates associations of models
  has_many :activities, through: :adventures
  has_many :states, through: :adventures

  validates_associated :adventures, :activities, :states  # validates associations
  
  validates :username, :email, presence: true # confirms presence attributes
  validates :password, length: { minimum: 7 }, unless: :no_password # confirm has password with length
  validates :username, uniqueness: { message: "%{value} is already taken. Try a different username"}, unless: :no_username  # confirm unique username
  validates :email, format: { with: /.{1,}@[^.]{1,}/, message: "is not valid"}, unless: :no_email  # confirm email format
  
  def slug  # creates slug from user instance
    self.username.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug) # finds user instance by slug
    self.all.find do |u|
      u.slug == slug
    end
  end
  
  def no_password  # checks if password is not present
    !password
  end

  def no_username # checks if username is not present
    !username
  end

  def no_email # check if no email
    !email
  end
end

# got email format regex from sigparser.com