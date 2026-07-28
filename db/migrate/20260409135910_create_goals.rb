class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.belongs_to :practice_activity
      t.belongs_to :user
      t.string :unit, null: false
      t.float :target_value, null: false
      t.boolean :active, default: true
      t.timestamps

      # only one goal active at the same time ?
      # add_index :goals, [ :user_id, :practice_activity_id ], unique: true, where: "active = 1"
    end
  end
end
