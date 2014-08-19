class AddPlaceIdToInformation < ActiveRecord::Migration
  def change
    add_column :information, :place_id, :integer
  end
end
