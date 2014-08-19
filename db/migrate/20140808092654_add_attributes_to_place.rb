class AddAttributesToPlace < ActiveRecord::Migration
  def change
    add_column :places, :province, :string
    add_column :places, :city, :string
    add_column :places, :street, :string
    add_column :places, :street_number, :string
  end
end
