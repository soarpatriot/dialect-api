class CreateMerchantTerms < ActiveRecord::Migration
  def change
    create_table :merchant_terms do |t|
      t.string :term_id
      t.string :integer
      t.string :merchant_id

      t.timestamps
    end
  end
end
