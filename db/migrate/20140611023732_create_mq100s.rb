class CreateMq100s < ActiveRecord::Migration
  def change
    create_table :mq100s do |t|
      t.string :service_code
      t.string :number
      t.integer :merchant_id

      t.timestamps
    end
  end
end
