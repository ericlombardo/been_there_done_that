class User < ActiveRecord::Base
  has_secure_password
  has_many :adventures
  has_many :activities, through: :adventures
end