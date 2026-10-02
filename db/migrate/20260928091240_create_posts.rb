class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.belongs_to :user, null: false
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt, null: false
      t.string :meta_description
      t.integer :status, null: false, default: 0
      t.datetime :published_at

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, [ :status, :published_at ]
  end
end
