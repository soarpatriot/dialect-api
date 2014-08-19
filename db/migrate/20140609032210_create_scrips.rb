class CreateScrips < ActiveRecord::Migration
  def change
    create_table :scrips do |t|
      t.text :content
      t.string :image
      t.integer :user_id
      t.float :longitude
      t.float :latitude
      t.string :address

      t.timestamps
    end
  end
end
