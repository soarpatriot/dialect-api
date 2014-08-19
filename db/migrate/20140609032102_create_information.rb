class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.string :infoable_type
      t.integer :infoable_id

      t.timestamps
    end
  end
end
