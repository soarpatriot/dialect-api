class CreateFriendshipRequests < ActiveRecord::Migration
  def change
    create_table :friendship_requests do |t|
      t.integer :user_id
      t.integer :target_user_id
      t.integer :status

      t.timestamps
    end
  end
end
