class AddPtypeToPlace < ActiveRecord::Migration
  def change
    add_column :places, :ptype, :string
  end
end
