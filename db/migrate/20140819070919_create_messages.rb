class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :chat, index: true
      t.string :avatar
      t.integer :user_id
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
