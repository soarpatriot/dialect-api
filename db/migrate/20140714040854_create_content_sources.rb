class CreateContentSources < ActiveRecord::Migration
  def change
    create_table :content_sources do |t|
      t.string :title
      t.string :content_rule
      t.string :image_rule
      t.string :url

      t.timestamps
    end
  end
end
