class AddAddrToPlace < ActiveRecord::Migration
  def change
    add_column :places, :addr, :string
  end
end
