class User < ActiveRecord::Base

  has_secure_password

  has_many :gameplans
  has_many :comments
  has_many :stars
  has_many :starred_gameplans, through: :stars, source: :gameplan

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthday, presence: true
  validates :username, presence: true
  validates_uniqueness_of :username, case_sensitive: false
  validates :username, format: { without: /\s/ }
  validates :password, presence: true
  validates :password, format: { without: /\s/ }

end