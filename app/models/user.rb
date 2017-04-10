class User < ActiveRecord::Base

  has_secure_password

  has_many :gamplans
  has_many :comments
  has_many :stars
  has_many :starred_gameplans, through: :stars, source: :gameplans

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates_uniqueness_of :username
  validates :password, presence: true

end