class AddModelToMq100s < ActiveRecord::Migration
  def change
    add_column :mq100s, :model, :string
  end
end
