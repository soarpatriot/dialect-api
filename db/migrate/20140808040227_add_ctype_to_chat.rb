class AddCtypeToChat < ActiveRecord::Migration
  def change
    add_column :chats, :ctype, :integer
  end
end
