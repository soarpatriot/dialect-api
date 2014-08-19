class CreateCheckinHistories < ActiveRecord::Migration
  def change
    create_table :checkin_histories do |t|
      t.string :service_code
      t.float :longitude
      t.float :latitude
      t.integer :user_id

      t.timestamps
    end
  end
end
