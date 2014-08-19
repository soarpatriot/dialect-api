class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :platform
      t.string :token
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
