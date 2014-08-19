class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :title
      t.string :logo
      t.integer :scrip_id
      t.boolean :always_show
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
