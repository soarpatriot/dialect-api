class AddIsDestroyed < ActiveRecord::Migration
  def change
    add_column :information, :is_destroyed, :boolean, default: false rescue nil
    add_column :scrips, :is_destroyed, :boolean, default: false rescue nil
  end
end
