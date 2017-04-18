class GameplanHelper

  def self.total_time(steps)
    total_time = 0
    steps.each do |step|
      if step.time_measure == "min"
        total_time += step.time_length
      elsif step.time_measure == "hour"
        total_time += (step.time_length*60)
      end
    end
    hours = total_time/60
    minutes = total_time%60
    if hours == 0
      if minutes == 1
        "Total Time: 1 minute"
      else
        "Total Time: #{minutes} minutes"
      end
    elsif hours == 1
      if minutes == 0
        "Total Time: 1 hour"
      elsif minutes == 1
        "Total Time: 1 hour & 1 minute"
      else
        "Total Time: 1 hour & #{minutes} minutes"
      end
    elsif hours > 1
      if minutes == 0
        "Total Time: #{hours} hours"
      elsif minutes == 1
        "Total Time: #{hours} hours & 1 minute"
      else
        "Total Time: #{hours} hours & #{minutes} minutes"
      end
    end
  end

  def self.set_category_or_error(category_value, category_name = "")
    if category_value == "new"
      if !category_name.empty?
        if category = Category.all.detect{|cat| cat.name == category_name}
          category
        else
          Category.new(name: category_name)
        end
      else
        ["Cannot create category without name"]
      end
    else
      Category.find(category_value)
    end
  end

  def self.add_steps(gameplan, steps)
    steps.each do |step_hash|
      step = Step.new
      step.time_length = step_hash[:time_length].to_i
      step.time_measure = step_hash[:time_measure]
      step.step_name = step_hash[:step_name]
      gameplan.steps << step
    end
  end

  def self.all_steps_valid?(steps)
    steps.all? do |step_hash|
      ((step_hash[:time_length] > 0) && (!step_hash[:step_name].empty?)) || ((step[:time_length.to_i == 0) && step_hash[:step_name].empty?))
    end
  end

end
