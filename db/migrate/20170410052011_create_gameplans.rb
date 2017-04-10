class CreateGameplans < ActiveRecord::Migration[5.0]
  def change
    create_table :gameplans do |t|
      t.string :title
      t.integer :category_id
      t.timestamps
    end
  end
end
