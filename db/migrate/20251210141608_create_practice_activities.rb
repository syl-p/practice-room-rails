class CreatePracticeActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :practice_activities do |t|
      t.belongs_to :practice
      t.belongs_to :activity
      t.integer :position
      t.timestamps
    end

    add_index :practice_activities, [:practice_id, :activity_id], unique: true
  end
end
