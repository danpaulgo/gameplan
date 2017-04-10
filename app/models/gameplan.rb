class Gameplan < ActiveRecord::Base
  has_many :steps
  has_many :comments
  has_many :stars
  belongs_to :user
  belongs_to :category

  validates :title, presence: true
  validates :category, presence: true
end