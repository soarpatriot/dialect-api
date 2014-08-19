class AddLogoToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :logo, :string
  end
end
