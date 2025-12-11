class CreatePracticeActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :practice_activities do |t|
      t.belongs_to :practice
      t.belongs_to :activity
      t.integer :position
      t.timestamps
    end
  end
end
