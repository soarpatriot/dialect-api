class AddParentIdToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :parent_id, :integer
  end
end
