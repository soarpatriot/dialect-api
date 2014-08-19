class RenameMerchantTermToCouponTerm < ActiveRecord::Migration
  def change
    rename_table :merchant_terms, :coupon_terms
    rename_column :coupon_terms, :merchant_id, :coupon_id
  end
end
