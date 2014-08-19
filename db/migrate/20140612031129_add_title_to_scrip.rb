class AddTitleToScrip < ActiveRecord::Migration
  def change
    add_column :scrips, :title, :string
  end
end
