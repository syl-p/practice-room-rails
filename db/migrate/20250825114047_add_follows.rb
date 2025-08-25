class AddFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.references :follower, foreign_key: { to_table: :users }
      t.references :following, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :follows, [:follower_id, :following_id], unique: true
  end
end
