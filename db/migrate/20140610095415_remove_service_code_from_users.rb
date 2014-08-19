class RemoveServiceCodeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :service_code
  end
end
