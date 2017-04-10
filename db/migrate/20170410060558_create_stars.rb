class CreateStars < ActiveRecord::Migration[5.0]
  def change
    create_table :stars do |t|
      t.integer :user_id
      t.integer :gameplan_id
    end
  end
end
