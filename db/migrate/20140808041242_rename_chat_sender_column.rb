class RenameChatSenderColumn < ActiveRecord::Migration
  def change
    rename_column :chats, :last_user_id, :last_sender_id
    rename_column :chats, :last_user_type, :last_sender_type
  end
end
