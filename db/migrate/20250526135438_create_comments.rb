class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :commentable, polymorphic: true
      t.text :content, null: false
      t.integer :parent_id, null: true
      t.timestamps
    end
  end
end
