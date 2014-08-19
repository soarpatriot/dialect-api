class CreateContentAddresses < ActiveRecord::Migration
  def change
    create_table :content_addresses do |t|
      t.string :value

      t.timestamps
    end
  end
end
