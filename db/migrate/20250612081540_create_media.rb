class CreateMedia < ActiveRecord::Migration[8.0]
  def change
    create_table :media do |t|
      t.timestamps
      t.string :name
      t.text :description
      t.belongs_to :user
    end

    create_join_table :media, :activities
  end
end
