class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.integer :notification_type, default: 0, null: false
      t.datetime :read_at
      t.timestamps
    end
  end
end
