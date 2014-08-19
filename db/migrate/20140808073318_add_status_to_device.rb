class AddStatusToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :status, :integer
  end
end
