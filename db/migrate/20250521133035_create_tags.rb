class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :taggings do |t|
      t.references :taggable, polymorphic: true, null: false
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end

    add_index :taggings, [ :taggable_id, :taggable_type, :tag_id ], unique: true
  end
end
