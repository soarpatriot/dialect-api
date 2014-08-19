class CreateErrorCodes < ActiveRecord::Migration
  def change
    create_table :error_codes do |t|
      t.integer :code
      t.string :summary
      t.string :category

      t.timestamps
    end
  end
end
