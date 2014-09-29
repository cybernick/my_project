require 'carrierwave/orm/activerecord'
class Article < ActiveRecord::Base
  include AASM
  attr_accessible :status,:title,:rating, :article_description, :name_of_photo, :id
  belongs_to :user
  belongs_to :admin
  has_many :ratings
  has_many :raters, :through => :ratings, :source => :users
  mount_uploader :name_of_photo, PhotosUploader
  validates :title, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :article_description, presence: true
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
end
