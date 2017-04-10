class Step < ActiveRecord::Base

  belongs_to :gameplan

  validates :time_length, presence: true
  validates :time_measure, presence: true
  validates :step_name, presence: true

end