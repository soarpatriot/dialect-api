class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :last_user_id
      t.string :last_message
      t.string :owner_type
      t.integer :owner_id
      t.datetime :last_sync_at

      t.timestamps
    end
  end
end
