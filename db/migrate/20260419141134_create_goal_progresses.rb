class CreateGoalProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :goal_progresses do |t|
      t.belongs_to :goal
      t.float :value, null: false
      t.timestamps
    end
  end
end
