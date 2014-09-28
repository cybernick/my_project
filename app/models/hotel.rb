require 'carrierwave/orm/activerecord'
class Hotel < ActiveRecord::Base
<<<<<<< HEAD
  include AASM
=======
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
  attr_accessible :status,:title,:rating,:breakfast,:price_for_room,:country,:state,:city,:street, :room_description, :name_of_photo, :id
  belongs_to :user
  belongs_to :admin
  has_many :ratings
  has_many :raters, :through => :ratings, :source => :users
  mount_uploader :name_of_photo, PhotosUploader
  validates :title, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :room_description, presence: true
  validates :price_for_room, presence: true,  numericality: true
  validates :country, presence: true
  validates :state, presence: true
  validates :city, presence: true
  validates :street, presence: true
  scope :status, -> (status) { where status: status }
  def average_rating
    @value = 0
    self.ratings.each do |rating|
      @value = @value + rating.value
    end
    @total = self.ratings.size
    '%.2f' % (@value.to_f / @total.to_f)
     update_attributes(rating:     '%.2f' % (@value.to_f / @total.to_f))
  end
<<<<<<< HEAD



  aasm :column => 'status' do
    state :pending, :initial => true
    state :approved
    state :rejected

    event :approve do
      transitions :from => :pending, :to => :approved
    end

    event :reject do
      transitions :from => :pending, :to => :rejected
    end
  end
=======
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
end
