class RemoveUserIdFromScrip < ActiveRecord::Migration
  def change
    remove_column :scrips, :user_id
  end
end
