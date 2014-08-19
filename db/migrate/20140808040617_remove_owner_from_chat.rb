class RemoveOwnerFromChat < ActiveRecord::Migration
  def change
    remove_column :chats, :owner_type
    remove_column :chats, :owner_id
  end
end
