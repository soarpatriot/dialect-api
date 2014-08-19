class AddLongitudeAndLatitudeToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :longitude, :float
    add_column :merchants, :latitude, :float
  end
end
