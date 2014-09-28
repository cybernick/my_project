class User < ActiveRecord::Base
  has_many :hotels
  has_many :ratings
  has_many :rated_hotels, :through => :ratings, :source => :hotels
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :provide, :uid, :name, :email, :password, :password_confirmation, :remember_me, :username, :id
  scope :starts_with_username, -> (username) { where("username like ?", "#{username}%")}
  scope :starts_with_email, -> (email) { where("email like ?", "#{email}%")}
end
