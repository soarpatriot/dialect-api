class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :url
      t.string :os
      t.integer :code
      t.boolean :mandatory

      t.timestamps
    end
  end
end
