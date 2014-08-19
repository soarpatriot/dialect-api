class CreateClauses < ActiveRecord::Migration
  def change
    create_table :clauses do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
