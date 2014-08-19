class AddInformationIdToChat < ActiveRecord::Migration
  def change
    add_column :chats, :information_id, :integer
  end
end
