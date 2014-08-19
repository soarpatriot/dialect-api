class AddDefaultValues < ActiveRecord::Migration
  def up
    change_column :coupons, :expire_at, :datetime, default: DateTime.now + 30.days
    change_column :coupons, :count, :integer, default: 0
  end

  def down
    change_column :coupons, :expire_at, :datetime
    change_column :coupons, :count, :integer
  end
end
