class AddDistrictToPlace < ActiveRecord::Migration
  def change
    add_column :places, :district, :string
  end
end
