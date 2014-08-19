class AddTargetToChat < ActiveRecord::Migration
  def change
    add_column :chats, :target_id, :integer
    add_column :chats, :target_type, :string
  end
end
