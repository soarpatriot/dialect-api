class AddTitleToTerms < ActiveRecord::Migration
  def change
    add_column :terms, :title, :string
  end
end
