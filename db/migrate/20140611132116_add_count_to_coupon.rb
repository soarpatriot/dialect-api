class AddCountToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :count, :integer
  end
end
