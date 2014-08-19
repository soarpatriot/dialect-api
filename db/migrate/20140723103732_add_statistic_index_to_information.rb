class AddStatisticIndexToInformation < ActiveRecord::Migration
  def change
    add_index :information, :votes_count
    add_index :information, :comments_count
    add_index :information, :shares_count
    add_index :information, :visits_count
  end
end
