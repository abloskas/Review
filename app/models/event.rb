class Event < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :attendees, dependent: :destroy
  has_many :attendents, through: :attendees, source: :user
  validates :name, :date, :city, :state, presence: true


  private
  def event_present_only
    errors.add(:date, "Date cannot be in the past") if !date.blank? and date < Date.today
  end
end
