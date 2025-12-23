class AddPracticeReferenceToPracticeEntries < ActiveRecord::Migration[8.0]
  def change
    add_belongs_to :practice_entries, :practice, null: false
  end
end
