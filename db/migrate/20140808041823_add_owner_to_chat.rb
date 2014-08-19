class AddOwnerToChat < ActiveRecord::Migration
  def change
    add_column :chats, :owner_id, :integer
    add_column :chats, :owner_type, :string
  end
end
