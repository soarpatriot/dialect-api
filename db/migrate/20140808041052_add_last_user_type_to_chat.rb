class AddLastUserTypeToChat < ActiveRecord::Migration
  def change
    add_column :chats, :last_user_type, :string
  end
end
