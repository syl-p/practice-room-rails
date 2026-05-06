class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content, null: false
      t.integer :status, default: 0, null: false
      t.string :default_unit
      t.integer :default_target_value
      t.belongs_to :user
      t.timestamps
    end
  end
end
