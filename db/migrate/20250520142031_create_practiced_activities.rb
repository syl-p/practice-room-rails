class CreatePracticedActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :practiced_activities do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :activity, null: false, foreign_key: true
      t.integer :duration, null: false, default: 0
      t.timestamps
    end
  end
end
