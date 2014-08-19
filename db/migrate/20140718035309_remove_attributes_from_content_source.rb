class RemoveAttributesFromContentSource < ActiveRecord::Migration
  def change
    remove_column :content_sources, :url
    remove_column :content_sources, :article_rule
    remove_column :content_sources, :image_rule
    remove_column :content_sources, :content_rule
  end
end
