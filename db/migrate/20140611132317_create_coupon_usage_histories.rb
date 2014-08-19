class CreateCouponUsageHistories < ActiveRecord::Migration
  def change
    create_table :coupon_usage_histories do |t|
      t.belongs_to :coupon, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
