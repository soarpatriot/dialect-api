class CheckinHistoryBelongsToMerchant < ActiveRecord::Migration
  def change
    remove_column :checkin_histories, :service_code
    add_column :checkin_histories, :merchant_id, :integer
  end
end
