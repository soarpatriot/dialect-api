class ChangeOsFromVersions < ActiveRecord::Migration
  def change
    rename_column :versions, :os, :platform
  end
end
