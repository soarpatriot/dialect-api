class CreateInformationVisitRecords < ActiveRecord::Migration
  def change
    create_table :information_visit_records do |t|
      t.belongs_to :information, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
