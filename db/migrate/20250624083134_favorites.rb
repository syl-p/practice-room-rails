class Favorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false
      t.references :activity, null: false
    end

    add_index :favorites, [:user_id, :activity_id], unique: true
  end
end
