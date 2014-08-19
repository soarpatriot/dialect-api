class CreateSoundinkCodes < ActiveRecord::Migration
  def change
    create_table :soundink_codes do |t|
      t.string :service_code
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
