class Rating < ActiveRecord::Base
  attr_accessible :value, :hotel_id, :user_id, :comment
  belongs_to :hotel
  belongs_to :user
  validates :hotel_id, presence: true 
  validates :user_id, presence: true
  validates :value, presence: true,numericality: true
end
