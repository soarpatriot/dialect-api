class AddAddressToComments < ActiveRecord::Migration
  def change
    add_column :comments, :address, :string
    add_column :comments, :string, :string
  end
end
