class CreateFavoritePlaces < ActiveRecord::Migration
  def change
    create_table :favorite_places do |t|
      t.belongs_to :place, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
