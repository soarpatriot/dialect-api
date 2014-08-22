class AddUserAvatarToScrip < ActiveRecord::Migration
  def change
    add_column :scrips, :user_avatar, :string, default: ""
  end
end
