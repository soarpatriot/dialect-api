class CreatePlaceUserRelations < ActiveRecord::Migration
  def change
    create_table :place_user_relations do |t|
      t.belongs_to :place, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
