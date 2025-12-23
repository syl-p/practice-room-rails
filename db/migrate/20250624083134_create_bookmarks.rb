class CreateBookmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false
      t.references :activity, null: false
    end

    add_index :bookmarks, [ :user_id, :activity_id ], unique: true
  end
end
