class CreateInformationShareRecords < ActiveRecord::Migration
  def change
    create_table :information_share_records do |t|
      t.integer :information_id
      t.integer :user_id

      t.timestamps
    end
  end
end
