class AddCategoryToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :category, :string
  end
end
