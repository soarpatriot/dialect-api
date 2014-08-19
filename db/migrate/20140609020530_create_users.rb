class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile_number
      t.string :password_digest
      t.string :nickname
      t.string :avatar

      t.timestamps
    end
  end
end
