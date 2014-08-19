class CreateCaptchas < ActiveRecord::Migration
  def change
    create_table :captchas do |t|
      t.string :mobile_number
      t.string :code
      t.integer :ctype

      t.timestamps
    end
  end
end
