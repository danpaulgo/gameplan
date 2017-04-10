class CreateSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :steps do |t|
      t.integer :time_length
      t.string :time_measure
      t.string :step_name
      t.integer :gameplan_id
    end
  end
end
