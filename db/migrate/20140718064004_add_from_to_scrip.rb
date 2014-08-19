class AddFromToScrip < ActiveRecord::Migration
  def change
    add_column :scrips, :from, :string
  end
end
