class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :reports, :scrip_id, :information_id
  end
end
