class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :image
      t.string :description
      t.string :owner_type
      t.integer :owner_id

      t.timestamps
    end
  end
end
