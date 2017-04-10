class AddUserIdToGameplans < ActiveRecord::Migration[5.0]
  def change
    add_column :gameplans, :user_id, :integer
  end
end
