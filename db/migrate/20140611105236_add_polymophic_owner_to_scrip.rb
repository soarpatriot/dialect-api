class AddPolymophicOwnerToScrip < ActiveRecord::Migration
  def change
    add_column :scrips, :owner_type, :string
    add_column :scrips, :owner_id, :integer
  end
end
