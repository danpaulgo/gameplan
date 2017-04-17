class Step < ActiveRecord::Base

  belongs_to :gameplan

  validates :time_length, presence: true
  validates_numericality_of :time_length, greater_than: 0
  validates :time_measure, presence: true
  validates :step_name, presence: true

  def display_step
    "#{self.step_name.capitalize} (#{self.time_length} #{self.time_measure}#{"s" if time_length > 1 && time_measure == "hour"})"
  end

end