class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.float :amount
      t.datetime :expire_at
      t.integer :merchant_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
