class AddArticleRuleToContentSource < ActiveRecord::Migration
  def change
    add_column :content_sources, :article_rule, :string
  end
end
