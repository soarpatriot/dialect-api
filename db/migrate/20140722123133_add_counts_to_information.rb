class AddCountsToInformation < ActiveRecord::Migration
  def change
    add_column :information, :shares_count, :integer, default: 0
    add_column :information, :votes_count, :integer, default: 0
    add_column :information, :comments_count, :integer, default: 0
    add_column :information, :visits_count, :integer, default: 0
  end
end
