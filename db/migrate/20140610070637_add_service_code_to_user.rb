class AddServiceCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :service_code, :string
  end
end
