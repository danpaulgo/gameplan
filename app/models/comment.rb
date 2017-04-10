class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :gameplan

  validates :content, presence: true

end