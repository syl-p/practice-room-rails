class CreatePractices < ActiveRecord::Migration[8.0]
  def change
    create_table :practices do |t|
      t.string :name
      t.text :description
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
