class AddStatusToCouponUsageHistory < ActiveRecord::Migration
  def change
    add_column :coupon_usage_histories, :status, :integer
  end
end
