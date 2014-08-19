class AddCodeToContentSource < ActiveRecord::Migration
  def change
    add_column :content_sources, :code, :text
  end
end
