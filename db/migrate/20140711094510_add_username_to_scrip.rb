class AddUsernameToScrip < ActiveRecord::Migration
  def change
    add_column :scrips, :username, :string rescue nil
  end
end
