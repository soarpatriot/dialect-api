class RemoveColumnFormComments < ActiveRecord::Migration
  def change
    remove_column :comments, :string
  end
end
