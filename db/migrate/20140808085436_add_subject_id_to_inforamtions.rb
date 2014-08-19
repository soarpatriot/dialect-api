class AddSubjectIdToInforamtions < ActiveRecord::Migration
  def change
    add_column :information, :subject_id, :integer
  end
end
