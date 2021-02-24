class User < ActiveRecord::Base
  has_secure_password
  has_many :adventures
  has_many :activities, through: :adventures
  has_many :states, through: :adventures
  validates_associated :adventures, :activities, :states
  validates :username, presence: { message: "must be present to proceed"}, if: :username_nil?
  validates_uniqueness_of :username, { message: "%{value} is already taken. Try another to proceed"}
  validates :email, presence: { message: "must be present to proceed"}

  def username_nil?
    !!username.nil?
  end
end