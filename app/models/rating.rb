class Rating < ActiveRecord::Base
  attr_accessible :value, :article_id, :user_id, :comment
  belongs_to :article
  belongs_to :user
  validates :article_id, presence: true 
  validates :user_id, presence: true
  validates :value, presence: true,numericality: true
end
