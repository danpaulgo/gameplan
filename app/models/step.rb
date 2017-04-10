class Step < ActiveRecord::Base

  belongs_to :gameplan

  validates :time_length, presence: true
  validates :time_measure, presence: true
  validates :description, presence: true

end