class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_secure_password
  has_many :events
  has_many :comments
  has_many :attendees
  validates :first_name, :last_name, :email, :city, :state, presence: true
  validates :email, format: {with: EMAIL_REGEX}, uniqueness: {case_sensitive: false}
end
