class AddPracticeReferenceToPracticedActivities < ActiveRecord::Migration[8.0]
  def change
    add_belongs_to :practiced_activities, :practice, null: false
  end
end
