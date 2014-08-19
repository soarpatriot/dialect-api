class AddPageToContentSource < ActiveRecord::Migration
  def change
    add_column :content_sources, :page, :integer, default: 1
  end
end
